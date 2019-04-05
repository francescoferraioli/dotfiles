# Install Homebrew /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

defaults write com.apple.finder AppleShowAllFiles YES

brew install git
brew install diff-so-fancy

brew cask install iterm2
brew cask install alacritty

brew install fd
brew install rg
brew install fzf 
brew install bat
brew install jq

brew install tmux
curl -L https://git.io/tmux-up -o /usr/local/bin/tmux-up

brew install zsh zsh-completions
brew install zsh-syntax-highlighting

# Install "Oh my ZSH"
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
sudo chsh -s /bin/zsh

# Install "Powerlevel9k Zsh Theme"
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

# Install base16 shell
git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell

curl https://nixos.org/nix/install | sh
nix-channel --remove nixpkgs
nix-channel --add https://nixos.org/channels/nixos-18.03 nixpkgs
nix-channel --update

./create-links.sh
