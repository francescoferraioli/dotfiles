# Install Homebrew /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

defaults write com.apple.finder AppleShowAllFiles YES
defaults write -g ApplePressAndHoldEnabled -bool false

# BREW
brew update
brew upgrade
brew doctor
brew bundle

# TMUX UP
curl -L https://git.io/tmux-up -o /usr/local/bin/tmux-up

# TMUXSPACE
curl https://raw.githubusercontent.com/francescoferraioli/tmuxspace/master/tmuxspace -o /usr/local/bin/tmuxspace

# BASE16 SHELL
git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell

./create-links.sh
