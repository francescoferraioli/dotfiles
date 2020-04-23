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

# BASE16 SHELL
git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell

# NIX
# curl https://nixos.org/nix/install | sh
# nix-channel --remove nixpkgs
# nix-channel --add https://nixos.org/channels/nixos-18.03 nixpkgs
# nix-channel --update

./create-links.sh
