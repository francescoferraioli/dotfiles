#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "$HOME"

repos=(dotfiles scripts ff frankie-claude frankie-assistant-canva)

pull_repo() {
  local repo="$1"
  if [[ ! -d "$repo" ]]; then
    echo ">>> Skipping $repo (not found)"
    return 0
  fi
  echo ">>> Pulling $repo..."
  git -C "$repo" fetch
  git -C "$repo" reset --hard '@{u}'
}

link_repo() {
  local repo="$1"
  local script
  if [[ ! -d "$repo" ]]; then
    return 0
  fi
  case "$repo" in
    dotfiles) script="canva-devbox/create-links.sh" ;;
    *) script="create-links.sh" ;;
  esac
  if [[ ! -f "$repo/$script" ]]; then
    return 0
  fi
  echo ">>> Running $repo $script..."
  (cd "$repo" && "./$script")
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
for repo in "${repos[@]}"; do
  pull_repo "$repo" &
  pids+=("$!")
done
wait_all "${pids[@]}"

# Link only after every checkout has been updated. The two link scripts write different files.
pids=()
for repo in "${repos[@]}"; do
  link_repo "$repo" &
  pids+=("$!")
done
wait_all "${pids[@]}"

echo ">>> Resync done."

"$SCRIPT_DIR/otter-setup.sh"
