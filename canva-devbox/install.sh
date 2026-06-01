# Install diff-so-fancy
npm install -g diff-so-fancy

sudo apt update
sudo apt install fonts-powerline
sudo apt install ripgrep
sudo apt install fzf
curl https://cursor.com/install -fsS | bash

curl -sS https://starship.rs/install.sh | sh -s -- -y

npm i -g https://github.com/canvanauts/realyze-git-pr-train.git

# Install Homebrew
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"

# git spice
brew install git-spice
