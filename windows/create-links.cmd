@echo off
cd %HOMEPATH%
call .\dotfiles\windows\create-link.cmd .bashrc dotfiles\bash\bashrc
call .\dotfiles\windows\create-link.cmd .inputrc dotfiles\bash\inputrc
call .\dotfiles\windows\create-link.cmd .gitconfig dotfiles\git\gitconfig
call .\dotfiles\windows\create-link.cmd .vimrc dotfiles\vim\vimrc
call .\dotfiles\windows\create-link.cmd .vsvimrc dotfiles\vim\vsvimrc
call .\dotfiles\windows\create-link.cmd .config\starship.toml dotfiles\starship\starship.toml