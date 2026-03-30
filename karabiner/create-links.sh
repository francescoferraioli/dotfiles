#!/usr/bin/env bash

set -e

CONFIG_DIR="$HOME/.config/karabiner"
REPO_FILE="$HOME/dotfiles/karabiner/karabiner.json"

mkdir -p "$CONFIG_DIR"
ln -sf "$REPO_FILE" "$CONFIG_DIR/karabiner.json"
