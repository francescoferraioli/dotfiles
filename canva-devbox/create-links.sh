
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
create_link ~/.gitconfig-devbox ~/dotfiles/git/gitconfig-devbox

if [[ "${USER:-}" == "coder" ]]; then
	echo ""
	echo "Removing stale devbox GitHub credential helper (/usr/bin/gh)"
	# gh auth setup-git may register the unauthenticated system gh binary.
	# gitconfig-devbox supplies /usr/local/bin/gh via includeIf instead.
	while git config --global --get-all credential.https://github.com.helper 2>/dev/null | grep -q '/usr/bin/gh'; do
		git config --global --unset credential.https://github.com.helper 2>/dev/null || break
	done
fi

echo ""
echo "Setting up gitignore links"
create_link ~/.gitignore ~/dotfiles/git/gitignore

echo ""
echo "Setting up bash links"
create_link ~/.bash.bashrc ~/dotfiles/bash/bashrc

echo ""
echo "Setting up tmux links"
create_link ~/.tmux.conf ~/dotfiles/tmux/tmux.conf

echo ""
echo "Setting up starship links"
create_link ~/.config/starship.toml ~/dotfiles/starship/starship.toml

echo ""
echo "Installing Canva pre-commit (taz fmt)"
# Resolve installer relative to this script so it works regardless of cwd.
DOTFILES_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
"$DOTFILES_ROOT/git/install-canva-pre-commit.sh"