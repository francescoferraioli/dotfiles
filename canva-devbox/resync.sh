#!/bin/bash

set -e

cd "$HOME"

for repo in dotfiles scripts ff frankie-claude; do
  if [[ -d "$repo" ]]; then
    echo ">>> Pulling $repo..."
    (cd "$repo" && git pull)
    if [[ -f "$repo/create-links.sh" ]]; then
      echo ">>> Running $repo create-links.sh..."
      (cd "$repo" && ./create-links.sh)
    fi
  else
    echo ">>> Skipping $repo (not found)"
  fi
done

echo ">>> Resync done."
