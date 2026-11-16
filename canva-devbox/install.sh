#!/usr/bin/env bash
set -e

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

apt_group() {
  sudo apt update
  sudo apt install -y fonts-powerline ripgrep
}

npm_group() {
  npm install -g diff-so-fancy
  npm i -g https://github.com/canvanauts/realyze-git-pr-train.git
}

starship_group() {
  curl -sS https://starship.rs/install.sh | sh -s -- -y
}

brew_group() {
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
  brew_safe install git-spice fzf fd
}

otter_skill_group() {
  otter workflow skill enable canva-pr-proof-of-work
}

# Apt, npm, Starship, and Homebrew do not share a package database.
# Homebrew packages stay in this group so they install after the prefix exists.
# Child shells drop the EXIT trap so they do not delete the shared brew git config.
start_group() {
  local name="$1"
  shift
  (
    trap - EXIT
    set -e
    set -o pipefail
    echo ">>> $name"
    "$@"
  ) &
  pids+=("$!")
}

wait_all() {
  local failed=0
  local pid
  for pid in "$@"; do
    if ! wait "$pid"; then
      failed=1
    fi
  done
  return "$failed"
}

pids=()
start_group "apt" apt_group
start_group "npm" npm_group
start_group "starship" starship_group
start_group "homebrew" brew_group
start_group "otter skill" otter_skill_group

if ! wait_all "${pids[@]}"; then
  echo ">>> Install failed." >&2
  exit 1
fi
