#!/usr/bin/env bash

set -e

SOURCE_FILE="$HOME/.config/karabiner/karabiner.json"
REPO_DIR="$HOME/dotfiles/karabiner"
DEST_FILE="$REPO_DIR/karabiner.json"

mkdir -p "$REPO_DIR"
cp "$SOURCE_FILE" "$DEST_FILE"