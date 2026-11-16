#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "$HOME"

sync_cloned_repo() {
  local url="$1"
  local name="${url##*/}"
  name="${name%.git}"
  echo ">>> Cloning $name..."
  git clone "$url"
  echo ">>> Fetching $name..."
  git -C "$name" fetch
  git -C "$name" reset --hard '@{u}'
}

wait_all() {
  local failed=0
  local pid
  for pid in "$@"; do
    if ! wait "$pid"; then
      failed=1
    fi
  done
  return "$failed"
}

pids=()
sync_cloned_repo https://github.com/francescoferraioli/scripts.git &
pids+=("$!")
sync_cloned_repo https://github.com/francescoferraioli/ff.git &
pids+=("$!")
sync_cloned_repo https://github.com/canvanauts/frankie-claude.git &
pids+=("$!")
sync_cloned_repo https://github.com/canvanauts/frankie-assistant-canva.git &
pids+=("$!")

echo ">>> Installing tools..."
"$SCRIPT_DIR/install.sh" &
pids+=("$!")

if ! wait_all "${pids[@]}"; then
  echo ">>> Setup failed." >&2
  exit 1
fi

# install.sh lives in this repo. resync resets dotfiles, so run it only after install returns.
"$SCRIPT_DIR/resync.sh"
