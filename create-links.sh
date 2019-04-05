#!/bin/bash

echo ""
echo "Setting up gitconfig links"
gitconfig=~/.gitconfig
rm "$gitconfig"
ln -s ~/dotfiles/git/gitconfig "$gitconfig"
ls -al "$gitconfig"

echo ""
echo "Setting up gitignore links"
gitignore=~/.gitignore
rm "$gitignore"
ln -s ~/dotfiles/git/gitignore "$gitignore"
ls -al "$gitignore"

echo ""
echo "Setting up zsh links"
zsh=~/.zshrc
rm "$zsh"
ln -s ~/dotfiles/zsh/zshrc "$zsh"
ls -al "$zsh"

echo ""
echo "Setting up alacritty links"
rm -rf ~/.config/alacritty
alacritty=~/.alacritty.yml
rm "$alacritty"
ln -s ~/dotfiles/alacritty/alacritty.yml "$alacritty"
ls -al "$alacritty"

echo ""
echo "Setting up vim links"
vim=~/.vimrc
rm "$vim"
ln -s ~/dotfiles/vim/vimrc "$vim"
ls -al "$vim"

echo ""
echo "Setting up tmux links"
tmux=~/.tmux.conf
rm "$tmux"
ln -s ~/dotfiles/tmux/tmux.conf "$tmux"
ls -al "$tmux"
