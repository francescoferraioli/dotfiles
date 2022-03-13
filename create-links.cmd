:: Run this from the root
@echo off
call .\dotfiles\create-link.cmd .bashrc dotfiles\bash\bashrc
call .\dotfiles\create-link.cmd .inputrc dotfiles\bash\inputrc
call .\dotfiles\create-link.cmd .gitconfig dotfiles\git\gitconfig
call .\dotfiles\create-link.cmd .vimrc dotfiles\vim\vimrc
call .\dotfiles\create-link.cmd .vsvimrc dotfiles\vim\vsvimrc
call .\dotfiles\create-link.cmd .config\starship.toml dotfiles\starship\starship.toml