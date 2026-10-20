#!/bin/sh
set -eu

volume=/home/node/.opencode-v2
[ ! -L "$volume" ] && [ -d "$volume" ] || {
  printf '%s\n' 'OpenCode state mount must be a real directory.' >&2
  exit 78
}

# The lifetime lock is deliberately in its own root-managed named volume.
# Node can manage its own entries, not unlink the root-owned lock binding.
[ "$(stat -c '%u:%g:%a' "$volume")" = "0:$(id -g node):1770" ] || {
  printf '%s\n' 'OpenCode state root must protect its owner-lock binding.' >&2
  exit 78
}

if [ "${1:-}" = ownership ]; then
  # Repair only this dedicated data volume. Do not cross mounts or follow
  # symlinks; malformed entries block rather than broadening ownership changes.
  if [ -e "$volume/xdg" ] && [ ! -L "$volume/xdg" ]; then
    if [ "$(stat -c '%u' "$volume/xdg")" != "$(id -u node)" ] && [ "$(stat -c '%u' "$volume/xdg")" != 0 ]; then
      printf '%s\n' 'OpenCode XDG root ownership is ambiguous; refusing to repair.' >&2
      exit 78
    fi
    unsafe=$(find -P "$volume/xdg" -xdev \( -type l -o \( ! -type f ! -type d \) \) -print -quit)
    [ -z "$unsafe" ] || {
      printf '%s\n' 'OpenCode XDG state contains symlinks or special files; refusing ownership repair.' >&2
      exit 78
    }
    if [ "$(stat -c '%u' "$volume/xdg")" != "$(id -u node)" ]; then chown node:node "$volume/xdg"; fi
    unsafe_owner=$(find -P "$volume/xdg" -xdev \( -type f -o -type d \) ! -user node ! -user root -print -quit)
    [ -z "$unsafe_owner" ] || {
      printf '%s\n' 'OpenCode XDG data contains a file with ambiguous ownership; refusing repair.' >&2
      exit 78
    }
    find -P "$volume/xdg" -xdev \( -type f -o -type d \) ! -user node -exec chown node:node {} +
  fi
  for path in "$volume/initialized" "$volume/initializing"; do
    if [ -e "$path" ] && [ ! -L "$path" ] && [ "$(stat -c '%u' "$path")" != "$(id -u node)" ]; then chown node:node "$path"; fi
  done
fi
