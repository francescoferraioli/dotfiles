
#!/bin/bash

create_link() {
    rm $1
    ln -s $2 $1
    ls -al $1
}

create_dir_link() {
    rm -rf $1
    ln -s $2 $1
    ls -al $1
}

echo ""
echo "Setting up gitconfig links"
create_link ~/.gitconfig ~/dotfiles/git/gitconfig
create_link ~/.gitconfig-canva ~/dotfiles/git/gitconfig-canva

echo ""
echo "Setting up gitignore links"
create_link ~/.gitignore ~/dotfiles/git/gitignore

echo ""
echo "Setting up bash links"
create_link ~/.bash.bashrc ~/dotfiles/bash/bashrc
