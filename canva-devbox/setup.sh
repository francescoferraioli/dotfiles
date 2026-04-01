#!/bin/bash

# Clone my repos
git clone https://github.com/francescoferraioli/scripts.git

git clone https://github.com/francescoferraioli/ff.git

git clone https://github.com/canvanauts/frankie-claude.git

./otter-setup.sh
./install.sh
./resync.sh