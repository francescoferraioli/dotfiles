cd ~

###############
# INSTALLERS
###############
# nix
# curl -L https://nixos.org/nix/install | sh
# brew
# /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

###############
# CLI INSTALL
###############
./dotfiles/mac/cli.nix.sh
./dotfiles/mac/cli.brew.sh

###############
# SCRIPTS
###############
git clone https://github.com/francescoferraioli/scripts.git ~/scripts

###############
# TMUX UP
###############
curl -L https://git.io/tmux-up -o /usr/local/bin/tmux-up
chmod u+x /usr/local/bin/tmux-up

###############
# TMUXSPACE
###############
curl https://raw.githubusercontent.com/francescoferraioli/tmuxspace/master/tmuxspace -o /usr/local/bin/tmuxspace
chmod u+x /usr/local/bin/tmuxspace

###############
# BASE16 SHELL
###############
git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell

###############
# DOTFILES SYMLINKS
###############
./dotfiles/mac/create-links.sh

###############
# APPLE SETTINGS
###############
defaults write com.apple.finder AppleShowAllFiles YES
defaults write -g ApplePressAndHoldEnabled -bool false

###############
# APP INSTALL
###############
./dotfiles/mac/cask.brew.sh