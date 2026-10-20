#!/bin/sh
set -eu
binary=${OPENCODE_V2_BINARY:-/opt/opencode/bin/opencode}
unset OPENCODE_DB
export XDG_DATA_HOME=/home/node/.opencode-v2/xdg/data
export XDG_STATE_HOME=/home/node/.opencode-v2/xdg/state
export XDG_CONFIG_HOME=/home/node/.opencode-v2/xdg/config
export XDG_CACHE_HOME=/home/node/.opencode-v2/xdg/cache

# Version/help calls run with temporary XDG locations so CLI metadata checks
# cannot create state that makes first-use import appear non-fresh.
metadata=0
if [ "$#" -eq 1 ]; then
  case "$1" in --version|--help|-h) metadata=1 ;; esac
fi

if [ "$#" -eq 3 ] && [ "$1" = debug ] && [ "$2" = paths ]; then
  case "$3" in
    db) printf '%s\n' "$XDG_DATA_HOME/opencode/opencode.db"; exit 0 ;;
    data) printf '%s\n' "$XDG_DATA_HOME/opencode"; exit 0 ;;
    state) printf '%s\n' "$XDG_STATE_HOME/opencode"; exit 0 ;;
    config) printf '%s\n' "$XDG_CONFIG_HOME/opencode"; exit 0 ;;
    cache) printf '%s\n' "$XDG_CACHE_HOME/opencode"; exit 0 ;;
  esac
fi
if [ "${1:-}" = auth ] && [ "${2:-}" = list ] && [ "$#" -eq 4 ] && [ "${3:-}" = --format ] && [ "${4:-}" = json ]; then
  exec /usr/local/bin/opencode-container-auth list-json
fi
if [ "$metadata" -eq 1 ]; then
  temporary=$(mktemp -d)
  trap 'rm -rf "$temporary"' EXIT HUP INT TERM
  if XDG_DATA_HOME="$temporary/data" XDG_STATE_HOME="$temporary/state" \
    XDG_CONFIG_HOME="$temporary/config" XDG_CACHE_HOME="$temporary/cache" \
    "$binary" "$@"; then
    status=0
  else
    status=$?
  fi
  rm -rf "$temporary"
  trap - EXIT HUP INT TERM
  exit "$status"
fi
/usr/local/bin/opencode-container-auth initialize
exec "$binary" "$@"
