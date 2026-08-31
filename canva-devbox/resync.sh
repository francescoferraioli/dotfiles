#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "$HOME"

for repo in dotfiles scripts ff frankie-claude; do
  if [[ -d "$repo" ]]; then
    echo ">>> Pulling $repo..."
    (cd "$repo" && git fetch && git reset --hard '@{u}')
    # Path to create-links.sh relative to repo root (default: create-links.sh)
    case "$repo" in
      dotfiles) script="canva-devbox/create-links.sh" ;;
      *) script="create-links.sh" ;;
    esac
    if [[ -f "$repo/$script" ]]; then
      echo ">>> Running $repo $script..."
      (cd "$repo" && ./"$script")
    fi
  else
    echo ">>> Skipping $repo (not found)"
  fi
done

echo ">>> Resync done."

"$SCRIPT_DIR/otter-setup.sh"