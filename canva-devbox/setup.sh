#!/bin/bash

npm install -g diff-so-fancy

otter claude-code mcp add otter otter mcp serve
otter config mcp enable-all

git clone https://github.com/francescoferraioli/scripts.git

git clone https://github.com/francescoferraioli/ff.git

git clone https://github.com/canvanauts/frankie-claude.git
./frankie-claude/create-links.sh
