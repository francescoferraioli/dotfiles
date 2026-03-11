#!/bin/bash
./dotfiles/canva-devbox/create-links.sh

# Install diff-so-fancy
npm install -g diff-so-fancy

# Install fonts and starship
sudo apt install fonts-powerline
curl -sS https://starship.rs/install.sh | sh

# Setup otter mcp
otter claude-code mcp add otter otter mcp serve
otter config mcp enable-all

# Clone my repos
git clone https://github.com/francescoferraioli/scripts.git

git clone https://github.com/francescoferraioli/ff.git

git clone https://github.com/canvanauts/frankie-claude.git
./frankie-claude/create-links.sh
