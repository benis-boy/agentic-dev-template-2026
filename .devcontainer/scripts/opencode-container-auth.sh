#!/bin/sh
set -eu

state=/home/node/.opencode-v2
owner_lock=/run/opencode-owner/container.lock
initialization_lock=/run/opencode-owner/initialization.lock
export XDG_DATA_HOME="$state/xdg/data"
export XDG_STATE_HOME="$state/xdg/state"
export XDG_CONFIG_HOME="$state/xdg/config"
export XDG_CACHE_HOME="$state/xdg/cache"
unset OPENCODE_DB
binary=${OPENCODE_V2_BINARY:-/opt/opencode/bin/opencode}
data="$XDG_DATA_HOME/opencode"
db="$data/opencode.db"
marker="$state/initialized"
initializing="$state/initializing"

cleanup_temporary_files() {
  if [ -n "${auth_diagnostic_dir:-}" ]; then
    rm -rf -- "$auth_diagnostic_dir"
  fi
  if [ -n "${tmpdir:-}" ]; then
    rm -rf -- "$tmpdir"
  fi
}
trap 'cleanup_temporary_files' EXIT
trap 'exit 1' HUP INT TERM

blocked() {
  printf 'OpenCode status: blocked; %s Project development remains available. Preserve state; do not retry with no-auth or delete the volume.\n' "$1" >&2
  exit 78
}

has_db_artifact() {
  for file in "$db" "$db-wal" "$db-shm" "$db-journal"; do
    [ ! -e "$file" ] && [ ! -L "$file" ] || return 0
  done
  return 1
}

valid_owner_binding() {
  [ "$(stat -c '%u:%g:%a' "$state")" = "0:$(id -g):1770" ] || return 1
  for record in /run/opencode-owner/identity "$state/.owner-lock-identity"; do
    [ -f "$record" ] && [ ! -L "$record" ] && [ -s "$record" ] || return 1
    [ "$(stat -c '%u:%h:%a' "$record")" = 0:1:440 ] || return 1
  done
  cmp -s /run/opencode-owner/identity "$state/.owner-lock-identity"
}

valid_database() {
  [ -f "$db" ] && [ ! -L "$db" ] && [ -s "$db" ] || return 1
  for file in "$db-wal" "$db-shm" "$db-journal"; do
    if [ -e "$file" ] || [ -L "$file" ]; then
      [ -f "$file" ] && [ ! -L "$file" ] || return 1
    fi
  done
  [ "$(stat -c '%u' "$db")" = "$(id -u)" ] || return 1
}

valid_initialized_database() {
  valid_owner_binding || return 1
  valid_database || return 1
  [ ! -L "$marker" ] && [ ! -L "$initializing" ] || return 1
  [ -f "$marker" ] && [ ! -L "$marker" ] && [ "$(stat -c '%a' "$marker")" = 600 ] || return 1
  [ ! -e "$initializing" ] && [ ! -L "$initializing" ] || return 1
  [ -f "$owner_lock" ] && [ ! -L "$owner_lock" ] && [ "$(stat -c '%u' "$owner_lock")" = 0 ] || return 1
  [ -f "$initialization_lock" ] && [ ! -L "$initialization_lock" ] && [ "$(stat -c '%u' "$initialization_lock")" = 0 ] || return 1
  [ "$(stat -c '%u' "$marker")" = "$(id -u)" ] || return 1
  for file in "$db" "$db-wal" "$db-shm" "$db-journal"; do
    if [ -e "$file" ] || [ -L "$file" ]; then
      [ "$(stat -c '%u' "$file")" = "$(id -u)" ] || return 1
    fi
  done
}

check_auth() {
  auth_diagnostic_dir=$(mktemp -d /tmp/opencode-auth-list.XXXXXX) || {
    auth_diagnostic='auth-list private diagnostic storage unavailable.'
    return 1
  }
  if ! chmod 0700 "$auth_diagnostic_dir"; then
    rm -rf -- "$auth_diagnostic_dir"
    auth_diagnostic='auth-list private diagnostic storage unavailable.'
    return 1
  fi
  auth_stderr="$auth_diagnostic_dir/stderr"
  if ! (umask 077; : > "$auth_stderr") 2>/dev/null || ! chmod 0600 "$auth_stderr"; then
    rm -rf -- "$auth_diagnostic_dir"
    auth_diagnostic='auth-list private diagnostic storage unavailable.'
    return 1
  fi

  auth_status=0
  if auth_diagnostic=$(node - "$binary" "$auth_stderr" 2>/dev/null <<'NODE'
const { spawn } = require("node:child_process");
const fs = require("node:fs");
const chunks = [];
let finished = false;
let stderrFd;
const stderrPath = process.argv[3];
const child = spawn(process.argv[2], ["auth", "list", "--format", "json", "--standalone"], {
  stdio: ["ignore", "pipe", (stderrFd = fs.openSync(stderrPath, "w", 0o600))],
});

function report(message, ready = false) {
  if (finished) return;
  finished = true;
  process.stdout.write(message + "\n");
  process.exitCode = ready ? 0 : 1;
}

function classifyStderr() {
  let stderr = "";
  try { stderr = fs.readFileSync(stderrPath, "utf8"); } catch {}
  const patterns = [
    ["config-validation", /invalid config|config(?:uration)? validation|failed to validate config|schema validation/i],
    ["tls-trust", /certificate|\bTLS\b|\bSSL\b|self[- ]signed|unable to verify/i],
    ["dns/connectivity", /getaddrinfo|\bENOTFOUND\b|\bECONNREFUSED\b|\bETIMEDOUT\b|connection reset|fetch failed|network error/i],
    ["database-lock/schema", /\bSQLITE_BUSY\b|database is locked|migration|database schema|sqlite/i],
    ["standalone-startup", /standalone|failed to start|startup|listen\(|address already in use|server failed/i],
    ["model-default/integration-list", /default model|model list|integration list|provider list|unknown model/i],
    ["credential/provider-auth", /credential|unauthori[sz]ed|authentication|\bauth(?:entication)? failed\b|invalid token|provider auth/i],
  ];
  const category = patterns.find(([, pattern]) => pattern.test(stderr))?.[0] ?? "other";
  const statusMatch = stderr.match(/\b(?:HTTP(?:\/\d(?:\.\d)?)?\s+|status(?: code)?\s*[=: ]\s*)([1-5]\d\d)\b/i);
  const knownFields = ["provider", "model", "default", "baseURL", "small_model", "disabled"];
  const field = category === "config-validation"
    ? knownFields.find((name) => new RegExp(`\\b${name}\\b`, "i").test(stderr))
    : undefined;
  return { category, status: statusMatch?.[1], field };
}

function cliFailure(code) {
  const { category, status, field } = classifyStderr();
  const details = [
    `exit-code=${code === null ? "unavailable" : code}`,
    `category=${category}`,
    ...(status ? [`http-status=${status}`] : []),
    ...(field ? [`config-field=${field}`] : []),
  ];
  report(`auth-list CLI failed; ${details.join("; ")}`);
}

child.stdout.on("data", (chunk) => chunks.push(chunk));
child.on("error", () => cliFailure(null));
child.on("close", (code) => {
  if (finished) return;
  if (code !== 0) {
    cliFailure(code);
    return;
  }

  const bytes = Buffer.concat(chunks);
  let value;
  try {
    value = JSON.parse(bytes.toString("utf8"));
  } catch {
    let leadingWhitespaceBytes = 0;
    while ([0x20, 0x09, 0x0a, 0x0d].includes(bytes[leadingWhitespaceBytes])) {
      leadingWhitespaceBytes++;
    }
    const whitespaceOnly = leadingWhitespaceBytes === bytes.length;
    const escapePrefix = bytes[leadingWhitespaceBytes] === 0x5c;
    report(`auth-list JSON parse failed; byte-count=${bytes.length}; leading-whitespace-bytes=${leadingWhitespaceBytes}; whitespace-only=${whitespaceOnly ? "yes" : "no"}; leading-escape-prefix=${escapePrefix ? "yes" : "no"}`);
    return;
  }

  const topLevelType = Array.isArray(value) ? "array" : value === null ? "null" : typeof value;
  const itemCount = Array.isArray(value)
    ? value.length
    : value !== null && typeof value === "object" ? Object.keys(value).length : 0;
  let integrationCount = 0;
  let credentialConnectionCount = 0;
  if (Array.isArray(value)) {
    for (const entry of value) {
      if (!entry || entry.id !== "github-copilot") continue;
      integrationCount++;
      if (Array.isArray(entry.connections)) {
        credentialConnectionCount += entry.connections.filter((connection) =>
          connection && connection.type === "credential"
        ).length;
      }
    }
  }

  const integrationPresent = integrationCount > 0;
  const credentialPresent = credentialConnectionCount > 0;
  const ready = integrationPresent && credentialPresent;
  report(`auth-list JSON top-level-type=${topLevelType}; item-count=${itemCount}; expected-integration-present=${integrationPresent ? "yes" : "no"}; expected-integration-count=${integrationCount}; credential-present=${credentialPresent ? "yes" : "no"}; credential-connection-count=${credentialConnectionCount}`, ready);
});

process.on("exit", () => {
  if (stderrFd !== undefined) {
    try { fs.closeSync(stderrFd); } catch {}
  }
  try { fs.unlinkSync(stderrPath); } catch {}
});
NODE
  ); then
    auth_status=0
  else
    auth_status=$?
  fi
  if ! rm -rf -- "$auth_diagnostic_dir"; then
    auth_diagnostic='auth-list private diagnostic cleanup failed.'
    return 1
  fi
  auth_diagnostic_dir=
  if [ "$auth_status" -eq 0 ]; then
    return 0
  else
    [ -n "$auth_diagnostic" ] || auth_diagnostic='auth-list diagnostic unavailable.'
    return 1
  fi
}

fresh_state() {
  valid_owner_binding || return 1
  [ ! -e "$marker" ] && [ ! -L "$marker" ] && [ ! -e "$initializing" ] && [ ! -L "$initializing" ] || return 1
  [ -f "$owner_lock" ] && [ ! -L "$owner_lock" ] && [ "$(stat -c '%u' "$owner_lock")" = 0 ] || return 1
  [ -f "$initialization_lock" ] && [ ! -L "$initialization_lock" ] && [ "$(stat -c '%u' "$initialization_lock")" = 0 ] || return 1
  ! has_db_artifact || return 1
  for item in "$state"/* "$state"/.[!.]* "$state"/..?*; do
    [ -e "$item" ] || [ -L "$item" ] || continue
    case "$item" in
      "$state/.owner-lock-identity") ;;
      "$state/xdg")
        [ -d "$item" ] && [ ! -L "$item" ] || return 1
        for sub in "$item"/* "$item"/.[!.]* "$item"/..?*; do
          [ -e "$sub" ] || [ -L "$sub" ] || continue
          case "$sub" in
            "$XDG_CACHE_HOME")
              [ -d "$sub" ] && [ ! -L "$sub" ] || return 1
              unsafe_cache=$(find -P "$sub" -xdev \( -type l -o \( ! -type f ! -type d \) \) -print -quit) || return 1
              [ -z "$unsafe_cache" ] || return 1 ;;
            *) return 1 ;;
          esac
        done ;;
      *) return 1 ;;
    esac
  done
  return 0
}

initialize() {
  [ "${1:-}" != blocked ] || blocked 'previous startup could not complete the approved initialization; protected state remains untouched.'
  lock="$initialization_lock"
  if [ -L "$lock" ] || [ ! -f "$lock" ] || [ "$(stat -c '%u' "$lock")" != 0 ]; then
    blocked 'the root-owned initialization lock is not a safe file.'
  fi
  [ -f "$lock" ] && [ ! -L "$lock" ] && [ "$(stat -c '%u' "$lock")" = 0 ] && [ -w "$lock" ] || blocked 'root-owned initialization lock is unavailable or unsafe.'
  [ -d "$state" ] && [ ! -L "$state" ] || blocked 'persistent data volume is not a safe directory.'
  [ -f "$owner_lock" ] && [ ! -L "$owner_lock" ] && [ "$(stat -c '%u' "$owner_lock")" = 0 ] || blocked 'lifetime lock mount is unavailable or unsafe.'
  [ -w "$state" ] || blocked 'OpenCode state volume is not writable by node.'
  exec 8>>"$lock"
  flock 8
  [ "$(stat -c '%u' "$lock")" = 0 ] || blocked 'initialization lock ownership changed after acquiring it.'
  valid_owner_binding || blocked 'the data volume is not bound to this protected owner-lock volume.'

  if [ -e "$initializing" ] || [ -L "$initializing" ]; then
    blocked 'an earlier initialization was interrupted and its partial state is preserved.'
  fi
  if [ -e "$marker" ] || [ -L "$marker" ]; then
    [ -f "$marker" ] && [ ! -L "$marker" ] && [ "$(stat -c '%a' "$marker")" = 600 ] || blocked 'the completion marker is unsafe.'
    [ "$(cat "$marker")" = legacy-imported-github-copilot ] || blocked 'the recorded initialization mode is unknown.'
    valid_initialized_database || blocked 'the recorded database, marker, lock or SQLite sidecars are missing or unsafe.'
    check_auth || blocked "$auth_diagnostic"
    check_plain_launcher || blocked 'the normal opencode launcher did not confirm readiness.'
    cleanup_external_stage
    printf '%s\n' 'OpenCode is ready: imported GitHub Copilot account is present in supported metadata.' >&2
    return 0
  fi
  if ! fresh_state; then
    blocked 'database, sidecar, credentials, marker, or partial state already exists without a valid completion record.'
  fi
  [ -f "$initialization_lock" ] && [ ! -L "$initialization_lock" ] && [ "$(stat -c '%u' "$initialization_lock")" = 0 ] || blocked 'root-owned initialization lock changed after fresh-state validation.'
  staged=/run/opencode-auth/auth.json
  if [ -L "$staged" ] || [ ! -f "$staged" ]; then
    blocked 'approved host GitHub Copilot auth is unavailable in the private read-only staging mount.'
  fi
  [ "$(stat -c '%u' "$staged")" = "$(id -u)" ] && [ "$(stat -c '%a' "$staged")" = 600 ] || blocked 'the staged credential owner or permissions are unsafe.'

  # Validate and transform in private /tmp first; no persistent volume mutation
  # occurs until the volume has passed the complete fresh-state inventory.
  tmpdir=$(mktemp -d /tmp/opencode-import.XXXXXX) || blocked 'private temporary import storage is unavailable.'
  chmod 0700 "$tmpdir"
  trap 'cleanup_temporary_files' EXIT HUP INT TERM
  import_file="$tmpdir/credential-import.json"
  if ! cp -- "$staged" "$tmpdir/host-auth.json"; then
    rm -rf -- "$tmpdir"
    blocked 'approved credential could not be copied to private temporary storage.'
  fi
  chmod 0600 "$tmpdir/host-auth.json"
  [ "$(stat -c '%a' "$tmpdir/host-auth.json")" = 600 ] || {
    rm -rf -- "$tmpdir"
    blocked 'private credential copy permissions are unsafe.'
  }
  if ! fresh_state; then
    rm -rf -- "$tmpdir"
    blocked 'persistent state changed during source validation; no credentials were imported into persistent state.'
  fi
  # Convert only the stable private copy; never publish credential JSON in state.
  if ! node - "$tmpdir/host-auth.json" "$import_file" <<'NODE'
const fs = require("node:fs");
try {
  const input = JSON.parse(fs.readFileSync(process.argv[2], "utf8"));
  if (!input || Array.isArray(input) || Object.keys(input).length !== 1 || !input["github-copilot"]) process.exit(1);
  const value = input["github-copilot"];
  const allowed = new Set(["type", "refresh", "access", "expires", "accountId", "enterpriseUrl"]);
  if (value.type !== "oauth" || typeof value.refresh !== "string" || typeof value.access !== "string" ||
      !Number.isSafeInteger(value.expires) || value.expires < 0 || Object.keys(value).some((key) => !allowed.has(key))) process.exit(1);
  const metadata = {};
  if (value.accountId !== undefined) { if (typeof value.accountId !== "string") process.exit(1); metadata.accountID = value.accountId; }
  if (value.enterpriseUrl !== undefined) { if (typeof value.enterpriseUrl !== "string") process.exit(1); metadata.enterpriseUrl = value.enterpriseUrl; }
  const entry = { id: "cred_" + require("node:crypto").randomBytes(20).toString("hex"), integrationID: "github-copilot", label: "GitHub Copilot (approved host import)", active: true,
    value: { type: "oauth", methodID: "device", refresh: value.refresh, access: value.access, expires: value.expires, ...(Object.keys(metadata).length ? { metadata } : {}) } };
  fs.writeFileSync(process.argv[3], JSON.stringify([entry]), { mode: 0o600, flag: "wx" });
} catch { process.exit(1); }
NODE
  then
    rm -rf -- "$tmpdir"
    blocked 'approved host file did not match the single GitHub Copilot OAuth credential schema.'
  fi

  if [ -e "$initializing" ] || [ -L "$initializing" ]; then
    rm -rf -- "$tmpdir"
    blocked 'initialization state appeared before import; preserving it.'
  fi
  [ -f "$initialization_lock" ] && [ ! -L "$initialization_lock" ] && [ "$(stat -c '%u' "$initialization_lock")" = 0 ] || {
    rm -rf -- "$tmpdir"
    blocked 'root-owned initialization lock changed; preserving the volume.'
  }
  [ -f "$owner_lock" ] && [ ! -L "$owner_lock" ] && [ "$(stat -c '%u' "$owner_lock")" = 0 ] || {
    rm -rf -- "$tmpdir"
    blocked 'protected lifetime lock changed before import; persistent state is preserved.'
  }
  if ! (umask 077; set -C; printf '%s\n' legacy-imported-github-copilot > "$initializing") 2>/dev/null; then
    rm -rf -- "$tmpdir"
    blocked 'could not safely establish the in-progress marker; persistent state was not changed.'
  fi
  chmod 0600 "$initializing"
  [ -f "$initialization_lock" ] && [ ! -L "$initialization_lock" ] && [ "$(stat -c '%u' "$initialization_lock")" = 0 ] || blocked 'root-owned initialization lock changed before auth DB access.'
  [ -f "$owner_lock" ] && [ ! -L "$owner_lock" ] && [ "$(stat -c '%u' "$owner_lock")" = 0 ] || blocked 'root-owned lifetime lock changed before auth DB access.'
  if ! "$binary" auth import --standalone < "$import_file" >/dev/null 2>&1; then
    rm -rf -- "$tmpdir"
    blocked 'the supported v2 credential import failed; partial database state is preserved.'
  fi
  valid_database || blocked 'the import did not create a safe non-empty OpenCode database.'
  check_auth || blocked "$auth_diagnostic"
  [ -f "$initializing" ] && [ ! -L "$initializing" ] || blocked 'initialization marker disappeared unexpectedly.'
  [ ! -e "$marker" ] && [ ! -L "$marker" ] || blocked 'completion state appeared during import; preserving it.'
  # One same-filesystem rename completes the transition under initialization
  # lock: no completed state can coexist with the in-progress marker.
  mv -T -- "$initializing" "$marker"
  rm -rf -- "$tmpdir"
  tmpdir=
  valid_initialized_database || blocked 'the published completion marker did not produce a valid initialized state.'
  check_auth || blocked "$auth_diagnostic"
  check_plain_launcher || blocked 'the normal opencode launcher did not confirm readiness after import.'
  cleanup_external_stage
  printf '%s\n' 'OpenCode is ready: supported metadata confirms the imported GitHub Copilot account. Token usability and model access are not asserted.' >&2
}

check_plain_launcher() {
  # This guarded metadata path validates completed state without recursively
  # acquiring initialization.lock. It exercises the normal PATH launcher.
  /usr/local/bin/opencode auth list --format json >/dev/null 2>&1
}

cleanup_external_stage() {
  receipt=/run/opencode-auth-receipt/consumed
  if [ -e "$receipt" ] || [ -L "$receipt" ]; then
    [ -f "$receipt" ] && [ ! -L "$receipt" ] || blocked 'host cleanup receipt path is unsafe.'
    return 0
  fi
  receipt_tmp="/run/opencode-auth-receipt/.consumed.$$"
  if [ -e "$receipt_tmp" ] || [ -L "$receipt_tmp" ]; then
    blocked 'temporary receipt path already exists; staged host credential remains private pending host cleanup.'
  fi
  if ! (umask 077; set -C; : > "$receipt_tmp") 2>/dev/null; then
    blocked 'could not create the host cleanup receipt; import readiness is not acknowledged.'
  fi
  chmod 0600 "$receipt_tmp"
  if [ -e "$receipt" ] || [ -L "$receipt" ]; then
    rm -f -- "$receipt_tmp"
    [ -f "$receipt" ] && [ ! -L "$receipt" ] || blocked 'host cleanup receipt raced with an unsafe path.'
    return 0
  fi
  mv -- "$receipt_tmp" "$receipt"
}

case "${1:-}" in
  status)
    valid_initialized_database || blocked 'approved first-use import has not completed.'
    [ "$(cat "$marker")" = legacy-imported-github-copilot ] || blocked 'the recorded initialization mode is unknown.'
    check_auth || blocked "$auth_diagnostic"
    printf '%s\n' 'OpenCode readiness: imported GitHub Copilot account is present in supported non-secret metadata.'
    ;;
  initialize)
    initialize
    ;;
  blocked)
    initialize blocked
    ;;
  list-json)
    valid_initialized_database || blocked 'approved first-use import has not completed.'
    [ "$(cat "$marker")" = legacy-imported-github-copilot ] || blocked 'the recorded initialization mode is unknown.'
    check_auth || blocked "$auth_diagnostic"
    exec "$binary" auth list --format json --standalone
    ;;
  *) printf '%s\n' 'Usage: opencode-container-auth {initialize|status}' >&2; exit 2 ;;
esac
