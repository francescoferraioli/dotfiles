#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Clone my repos
git clone https://github.com/francescoferraioli/scripts.git

git clone https://github.com/francescoferraioli/ff.git

git clone https://github.com/canvanauts/frankie-claude.git

git clone https://github.com/canvanauts/frankie-assistant-canva.git

"$SCRIPT_DIR/otter-setup.sh"
"$SCRIPT_DIR/install.sh"
"$SCRIPT_DIR/resync.sh"
