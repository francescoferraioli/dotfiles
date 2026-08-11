#!/usr/bin/env bash

# Devbox puts Canva's cg git wrapper first on PATH (/etc/bash.bashrc). Homebrew's
# auto `brew update` then hangs in a recursive `git config --includes` subprocess
# tree (or waits on difftool config). Agent shells usually hit /usr/bin/git first,
# which is why it works there but not in an interactive terminal.
BREW_GIT_CONFIG="$(mktemp)"
trap 'rm -f "$BREW_GIT_CONFIG"' EXIT
cat > "$BREW_GIT_CONFIG" <<'EOF'
[user]
	name = Homebrew
	email = brew@localhost
EOF

export HOMEBREW_GIT_PATH=/usr/bin/git
export CI=1
export NONINTERACTIVE=1
export HOMEBREW_NO_ASK=1
export HOMEBREW_NO_AUTO_UPDATE=1

brew_safe() {
  GIT_CONFIG_GLOBAL="$BREW_GIT_CONFIG" \
  GIT_CONFIG_SYSTEM=/dev/null \
  PATH="/usr/bin:/bin:$PATH" \
  HOMEBREW_GIT_PATH=/usr/bin/git \
  HOMEBREW_NO_AUTO_UPDATE=1 \
  brew "$@"
}

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
  GIT_CONFIG_GLOBAL="$BREW_GIT_CONFIG" \
  GIT_CONFIG_SYSTEM=/dev/null \
  PATH="/usr/bin:/bin:$PATH" \
  HOMEBREW_GIT_PATH=/usr/bin/git \
  HOMEBREW_NO_AUTO_UPDATE=1 \
  NONINTERACTIVE=1 \
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"

# git spice
brew_safe install git-spice

brew_safe install fzf fd