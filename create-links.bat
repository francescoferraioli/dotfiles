:: Run this from the root
@echo off
call .\dotfiles\create-link.bat .bashrc dotfiles\bash\bashrc
call .\dotfiles\create-link.bat .inputrc dotfiles\bash\inputrc
call .\dotfiles\create-link.bat .gitconfig dotfiles\git\gitconfig
call .\dotfiles\create-link.bat .vimrc dotfiles\vim\vimrc
call .\dotfiles\create-link.bat .vsvimrc dotfiles\vim\vsvimrc
call .\dotfiles\create-link.bat .config\starship.toml dotfiles\starship\starship.toml