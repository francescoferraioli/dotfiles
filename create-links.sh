#!/bin/bash

echo ""
echo "Setting up spectacle links"
spectacle=~/Library/Application\ Support/Spectacle/Shortcuts.json
rm "$spectacle"
ln -s ~/.dotfiles/spectacle/Shortcuts.json "$spectacle"
ls -al "$spectacle"

echo ""
echo "Setting up zsh links"
zsh=~/.zshrc
rm "$zsh"
ln -s ~/.dotfiles/zsh/zshrc "$zsh"
ls -al "$zsh"

echo ""
echo "Setting up MacOS keybinding links"
keybinding=~/Library/KeyBindings/DefaultKeyBinding.dict
mkdir -p ~/Library/KeyBindings
rm "$keybinding"
ln -s ~/.dotfiles/macos/DefaultKeyBinding.dict "$keybinding"
ls -al "$keybinding"

echo ""
echo "Setting up vscode links (requires admin password to create link)"
vscode=~/Library/Application\ Support/Code/User
rm "$vscode/keybindings.json"
sudo ln -s ~/.dotfiles/vscode/keybindings.json "$vscode/keybindings.json"
rm "$vscode/settings.json"
sudo ln -s ~/.dotfiles/vscode/settings.json "$vscode/settings.json"
ls -al "$vscode/settings.json" "$vscode/keybindings.json"

echo ""
echo "Setting up alacritty links"
rm -rf ~/.config/alacritty
alacritty=~/.alacritty.yml
rm "$alacritty"
ln -s ~/.dotfiles/alacritty/alacritty.yml "$alacritty"
ls -al "$alacritty"

echo ""
echo "Setting up vim links"
vim=~/.vimrc
rm "$vim"
ln -s ~/.dotfiles/vim/vimrc "$vim"
ls -al "$vim"

echo ""
echo "Setting up tmux links"
tmux=~/.tmux.conf
rm "$tmux"
ln -s ~/.dotfiles/tmux/tmux.conf "$tmux"
ls -al "$tmux"
