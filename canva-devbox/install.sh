#!/usr/bin/env bash

# Devbox puts Canva's cg git wrapper first on PATH (/etc/bash.bashrc). Homebrew's
# post-install `brew update` then hangs in a recursive `git config --includes`
# subprocess tree. Agent shells usually hit /usr/bin/git first, which is why it
# works there but not in an interactive terminal.
export HOMEBREW_GIT_PATH=/usr/bin/git
export CI=1
export NONINTERACTIVE=1
export HOMEBREW_NO_ASK=1

# Install diff-so-fancy
npm install -g diff-so-fancy

sudo apt update
sudo apt install -y fonts-powerline
sudo apt install -y ripgrep
curl https://cursor.com/install -fsS | bash

curl -sS https://starship.rs/install.sh | sh -s -- -y

npm i -g https://github.com/canvanauts/realyze-git-pr-train.git

# Install Homebrew
if [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  echo "Homebrew already installed, skipping installer"
else
  HOMEBREW_NO_AUTO_UPDATE=1 NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"


# git spice
brew install -y git-spice

brew install -y fzf fd