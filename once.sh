# Install base16 shell
git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell

# Install Homebrew /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew install git
brew cask install iterm2
brew install zsh zsh-completions
brew install fd
brew install rg
brew install fzf 
brew cask install alacritty
brew install tmux
brew install bat

#### Git

brew install diff-so-fancy
git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
git config --global color.ui true
git config --global color.diff-highlight.oldNormal    "red bold"
git config --global color.diff-highlight.oldHighlight "red bold 52"
git config --global color.diff-highlight.newNormal    "green bold"
git config --global color.diff-highlight.newHighlight "green bold 22"
git config --global color.diff.meta       "yellow"
git config --global color.diff.frag       "magenta bold"
git config --global color.diff.commit     "yellow bold"
git config --global color.diff.old        "red bold"
git config --global color.diff.new        "green bold"
git config --global color.diff.whitespace "red reverse"

git config --global core.editor vim

#####

defaults write com.apple.finder AppleShowAllFiles YES

# Install "Oh my ZSH"
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Install "Powerlevel9k Zsh Theme"
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

brew install zsh-syntax-highlighting

sudo rm -rf ~/Documents
sudo rm -rf ~/Music
sudo rm -rf ~/Movies
sudo rm -rf ~/Public
sudo rm -rf ~/Pictures
mkdir -p ~/Code

curl https://nixos.org/nix/install | sh
nix-channel --remove nixpkgs
nix-channel --add https://nixos.org/channels/nixos-18.03 nixpkgs
nix-channel --update

./create-links.sh
