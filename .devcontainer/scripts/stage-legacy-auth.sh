#!/usr/bin/env bash
set -euo pipefail
umask 077
trap 'printf "%s\\n" "OpenCode auth staging is unavailable or unsafe; project development continues while OpenCode remains guarded." >&2; exit 0' ERR

container_id=${1:?devcontainer ID required}
home=${HOME:?HOME is unavailable}
stage_root="$home/.agentic-devcontainer-auth"
stage="$stage_root/$container_id"
receipt_root="$home/.agentic-devcontainer-auth-receipts"
receipt="$receipt_root/$container_id"

case "$container_id" in
  ''|*[!a-zA-Z0-9_-]*) printf '%s\n' 'OpenCode auth staging blocked: invalid private staging identifier.' >&2; exit 0 ;;
esac

blocked() {
  printf 'OpenCode auth staging blocked: %s Project development continues; OpenCode remains guarded.\n' "$1" >&2
  exit 0
}

if [[ ! -e "$stage_root" ]]; then mkdir -m 0700 -- "$stage_root" || blocked 'private staging directory could not be created.'; fi
if [[ -L "$stage_root" || ! -d "$stage_root" || $(stat -c '%u' "$stage_root") != "$(id -u)" ]]; then
  blocked 'private staging parent is unsafe.'
fi
chmod 0700 "$stage_root" || blocked 'private staging directory permissions could not be set.'
if [[ -L "$stage" ]]; then
  blocked 'project staging directory is a symlink.'
fi
if [[ ! -e "$stage" ]]; then mkdir -m 0700 -- "$stage" || blocked 'project staging directory could not be created.'; fi
if [[ -L "$stage" || ! -d "$stage" || $(stat -c '%u' "$stage") != "$(id -u)" ]]; then
  blocked 'project staging directory is unsafe.'
fi
chmod 0700 "$stage" || blocked 'project staging directory permissions could not be set.'
if [[ ! -e "$receipt_root" ]]; then mkdir -m 0700 -- "$receipt_root" || blocked 'cleanup-receipt directory could not be created.'; fi
if [[ -L "$receipt_root" || ! -d "$receipt_root" || $(stat -c '%u' "$receipt_root") != "$(id -u)" ]]; then
  blocked 'cleanup-receipt parent is unsafe.'
fi
if [[ ! -e "$receipt" ]]; then mkdir -m 0700 -- "$receipt" || blocked 'cleanup-receipt path could not be created.'; fi
if [[ -L "$receipt" || ! -d "$receipt" || $(stat -c '%u' "$receipt") != "$(id -u)" ]]; then
  blocked 'cleanup-receipt directory is unsafe.'
fi
chmod 0700 "$receipt_root" "$receipt" || blocked 'cleanup-receipt permissions could not be set.'

# This setup is supported only with a local Docker daemon; do not stage a host
# credential where a remote daemon could not securely and predictably mount it.
context=$(docker context show 2>/dev/null) || {
  blocked 'Docker daemon locality could not be established.'
}
endpoint=$(docker context inspect "$context" --format '{{(index .Endpoints "docker").Host}}' 2>/dev/null) || endpoint=
case "${DOCKER_HOST:-$endpoint}" in
  unix://*) ;;
  *) blocked 'this configuration requires a local Unix-socket Docker daemon.' ;;
esac

destination="$stage/auth.json"
if [[ -e "$receipt/consumed" || -L "$receipt/consumed" ]]; then
  if [[ -L "$receipt/consumed" || ! -f "$receipt/consumed" ]]; then
    blocked 'cleanup receipt path is unsafe.'
  fi
  if [[ -e "$destination" || -L "$destination" ]]; then
    [[ -f "$destination" && ! -L "$destination" && $(stat -c '%u' "$destination") == "$(id -u)" ]] || blocked 'staged credential path is unsafe; it was preserved.'
    rm -- "$destination" || blocked 'staged credential cleanup failed.'
  fi
  # Keep the receipt so subsequent starts do not stage this host credential again.
  exit 0
fi
if [[ -e "$destination" || -L "$destination" ]]; then
  if [[ -L "$destination" || ! -f "$destination" || $(stat -c '%u' "$destination") != "$(id -u)" ]]; then
    blocked 'existing staged path is unsafe; it was preserved.'
  fi
  blocked 'an unacknowledged staged credential already exists; refusing to overwrite or restage it.'
fi

source=${OPENCODE_AUTH_FILE:-}
if [[ -z "$source" ]]; then
  data_home=${XDG_DATA_HOME:-"$home/.local/share"}
  source="$data_home/opencode/auth.json"
fi
if [[ -L "$source" || ! -f "$source" || $(stat -c '%u' "$source" 2>/dev/null || true) != "$(id -u)" ]]; then
  printf '%s\n' 'OpenCode auth staging blocked: the approved host v1 auth file is missing, not a regular file, a symlink, or not owned by this user. Project development remains available; OpenCode is blocked.' >&2
  exit 0
fi

source_mode=$(stat -c '%a' "$source")
source_identity=$(stat -c '%d:%i' "$source")
if (( (8#$source_mode & 077) != 0 )); then
  chmod 0600 -- "$source" || blocked 'approved credential file permissions could not safely be tightened.'
fi
temporary=$(mktemp "$stage/.auth.XXXXXXXX") || blocked 'private temporary staging file could not be created.'
trap 'rm -f -- "$temporary"' EXIT
cp --no-dereference -- "$source" "$temporary" || blocked 'approved credential could not be copied to private staging.'
if [[ -L "$temporary" || ! -f "$temporary" ]]; then
  blocked 'source changed to a non-regular file during staging.'
fi
[[ $(stat -c '%d:%i' "$source") == "$source_identity" ]] || blocked 'credential source changed during staging.'
chmod 0600 "$temporary" || blocked 'private staged credential permissions could not be set.'
mv -f -- "$temporary" "$destination" || blocked 'private staged credential could not be published atomically.'
trap - EXIT
printf '%s\n' 'Approved legacy auth staged privately for one-time OpenCode import; no credential data was displayed.'
