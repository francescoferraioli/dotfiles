#!/bin/bash

set -e

cd "$HOME"

# Optional: path to create-links.sh relative to repo root (default: create-links.sh)
declare -A create_links_path=(
  [dotfiles]="canva-devbox/create-links.sh"
)

for repo in dotfiles scripts ff frankie-claude; do
  if [[ -d "$repo" ]]; then
    echo ">>> Pulling $repo..."
    (cd "$repo" && git fetch && git reset --hard '@{u}')
    script="${create_links_path[$repo]:-create-links.sh}"
    if [[ -f "$repo/$script" ]]; then
      echo ">>> Running $repo $script..."
      (cd "$repo" && ./"$script")
    fi
  else
    echo ">>> Skipping $repo (not found)"
  fi
done

echo ">>> Resync done."
