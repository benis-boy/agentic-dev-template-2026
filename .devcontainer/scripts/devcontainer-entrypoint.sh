#!/bin/sh
set -eu

state=/home/node/.opencode-v2
owner_dir=/run/opencode-owner
lock="$owner_dir/container.lock"
init_lock="$owner_dir/initialization.lock"
if [ -L "$state" ] || [ ! -d "$state" ]; then
  printf '%s\n' 'OpenCode volume must be a real mounted directory.' >&2
  exit 78
fi
if [ "$(id -u)" -ne 0 ]; then
  printf '%s\n' 'Container entrypoint must start as root to acquire the volume owner lock safely.' >&2
  exit 78
fi

if [ -L "$owner_dir" ] || [ ! -d "$owner_dir" ] || [ "$(stat -c '%u' "$owner_dir")" != 0 ]; then
  printf '%s\n' 'OpenCode owner-lock volume must be a root-owned directory.' >&2
  exit 78
fi
chgrp "$(id -g node)" "$owner_dir"
chmod 0750 "$owner_dir"
if [ -L "$lock" ] || { [ -e "$lock" ] && { [ ! -f "$lock" ] || [ "$(stat -c '%u' "$lock")" != 0 ]; }; }; then
  printf '%s\n' 'OpenCode lifetime lock is unsafe; refusing to replace it.' >&2
  exit 78
fi
if [ ! -e "$lock" ]; then
  (umask 077; set -C; : > "$lock") 2>/dev/null || {
    printf '%s\n' 'Could not safely create the OpenCode lifetime lock.' >&2
    exit 78
  }
  chgrp node "$lock"
  chmod 0660 "$lock"
fi
if [ -L "$init_lock" ] || { [ -e "$init_lock" ] && { [ ! -f "$init_lock" ] || [ "$(stat -c '%u' "$init_lock")" != 0 ]; }; }; then
  printf '%s\n' 'OpenCode initialization lock is unsafe; refusing startup.' >&2
  exit 78
fi
if [ ! -e "$init_lock" ]; then
  (umask 077; set -C; : > "$init_lock") 2>/dev/null || {
    printf '%s\n' 'Could not safely create the OpenCode initialization lock.' >&2
    exit 78
  }
  chgrp node "$init_lock"
  chmod 0660 "$init_lock"
fi
if [ ! -f "$init_lock" ] || [ -L "$init_lock" ] || [ "$(stat -c '%u' "$init_lock")" != 0 ]; then
  printf '%s\n' 'OpenCode initialization lock changed during setup; refusing startup.' >&2
  exit 78
fi
if [ ! -f "$lock" ] || [ -L "$lock" ] || [ "$(stat -c '%u' "$lock")" != 0 ]; then
  printf '%s\n' 'OpenCode lifetime lock changed during setup; refusing startup.' >&2
  exit 78
fi
chgrp "$(id -g node)" "$lock" "$init_lock"
chmod 0660 "$lock" "$init_lock"
exec 9>>"$lock"
if ! flock -n 9; then
  printf '%s\n' 'Another container owns this OpenCode volume; refusing startup before database access.' >&2
  exit 78
fi
if [ "$(stat -c '%u' "$lock")" != 0 ]; then
  printf '%s\n' 'OpenCode lifetime lock ownership changed after acquisition; refusing database access.' >&2
  exit 78
fi
# Bind this protected lock volume to the data volume. A substituted lock volume
# must not provide a second independent lifetime lock for the same database.
# The sticky, root-owned data root lets node manage its own state, but not
# replace/unlink this root-owned binding. No database is opened here.
case "$(stat -c '%u' "$state")" in
  0|"$(id -u node)") ;;
  *) printf '%s\n' 'OpenCode data volume ownership is ambiguous.' >&2; exit 78 ;;
esac
chown "0:$(id -g node)" "$state"
chmod 1770 "$state"
identity="$owner_dir/identity"
binding="$state/.owner-lock-identity"
for record in "$identity" "$binding"; do
  if [ -L "$record" ] || { [ -e "$record" ] && { [ ! -f "$record" ] || [ "$(stat -c '%u:%h' "$record")" != 0:1 ]; }; }; then
    printf '%s\n' 'OpenCode volume lock identity is unsafe; preserving it.' >&2
    exit 78
  fi
done
if [ ! -e "$identity" ]; then
  (umask 077; set -C; cat /proc/sys/kernel/random/uuid > "$identity") || exit 78
fi
chgrp "$(id -g node)" "$identity"
chmod 0440 "$identity"
if [ ! -e "$binding" ]; then
  # Exclusive creation also serializes competing first-use lock-volume bindings.
  (umask 077; set -C; cat "$identity" > "$binding") || exit 78
fi
chgrp "$(id -g node)" "$binding"
chmod 0440 "$binding"
if [ ! -s "$identity" ] || ! cmp -s "$identity" "$binding"; then
  printf '%s\n' 'OpenCode data is bound to a different owner-lock volume; refusing database access.' >&2
  exit 78
fi
# Do not open the DB before the volume-only ownership repair. A blocked
# optional credential is diagnostic; the project shell remains available.
if ! /usr/local/libexec/devcontainer/opencode-volume-init.sh ownership; then
  printf '%s\n' 'OpenCode volume ownership initialization failed while holding the lifetime lock.' >&2
  exit 78
fi
if ! env HOME=/home/node USER=node LOGNAME=node \
  setpriv --reuid=node --regid=node --init-groups -- /usr/local/bin/opencode-container-auth initialize; then
  printf '%s\n' 'OpenCode initialization is blocked; project shell remains available.' >&2
fi
exec env HOME=/home/node USER=node LOGNAME=node \
  setpriv --reuid=node --regid=node --init-groups -- "$@"
