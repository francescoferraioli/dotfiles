#!/bin/bash

create_link() {
    rm $1
    ln -s $2 $1
    ls -al $1
}

echo ""
echo "Setting up gitconfig links"
create_link ~/.gitconfig ~/dotfiles/git/gitconfig

echo ""
echo "Setting up gitignore links"
create_link ~/.gitignore ~/dotfiles/git/gitignore

echo ""
echo "Setting up zsh links"
create_link ~/.zshrc ~/dotfiles/zsh/zshrc

echo ""
echo "Setting up alacritty links"
rm -rf ~/.config/alacritty
create_link ~/.alacritty.yml ~/dotfiles/alacritty/alacritty.yml

echo ""
echo "Setting up vim links"
create_link ~/.vimrc ~/dotfiles/vim/vimrc

echo ""
echo "Setting up tmux links"
create_link ~/.tmux.conf ~/dotfiles/tmux/tmux.conf
