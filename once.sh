# Install Homebrew /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

defaults write com.apple.finder AppleShowAllFiles YES

# BREW
brew update
brew upgrade
brew doctor
brew bundle

# TMUX UP
curl -L https://git.io/tmux-up -o /usr/local/bin/tmux-up

# OH MY ZSH
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
sudo chsh -s /bin/zsh

# POWERLEVEL9K ZSH THEME
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

# BASE16 SHELL
git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell

# NIX
curl https://nixos.org/nix/install | sh
nix-channel --remove nixpkgs
nix-channel --add https://nixos.org/channels/nixos-18.03 nixpkgs
nix-channel --update

./create-links.sh
