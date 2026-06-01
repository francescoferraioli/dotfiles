#!/bin/sh
# Pick a local branch with fzf and print its name to stdout (for composition).
# Usage: select-branch.sh [branch-name]
#   select-branch.sh              → interactive picker (newest branches first)
#   select-branch.sh my-branch    → echo my-branch
#   git checkout $(select-branch.sh)
#   git rebase $(select-branch.sh)
#   git coi                       → checkout via picker (git alias wraps this script)

set -eu

if [ $# -gt 0 ]; then
	echo "$1"
	exit 0
fi

if ! git rev-parse --git-dir >/dev/null 2>&1; then
	echo "select-branch: not a git repository" >&2
	exit 1
fi

if ! command -v fzf >/dev/null 2>&1; then
	for dir in /opt/homebrew/opt/fzf/bin /usr/local/opt/fzf/bin; do
		if [ -x "$dir/fzf" ]; then
			PATH="$dir:$PATH"
			export PATH
			break
		fi
	done
fi

if ! command -v fzf >/dev/null 2>&1; then
	echo "select-branch: fzf not found (brew install fzf)" >&2
	exit 1
fi

current="$(git branch --show-current 2>/dev/null || true)"
header="Current: ${current:-<detached>}"

selected="$(
	git for-each-ref --sort=-committerdate refs/heads/ \
		--format='%(refname:short)' \
		| fzf \
			--header="$header" \
			--height=40% \
			--layout=reverse \
			--preview='git --no-pager log -1 --format="%C(yellow)%h%Creset %d%n%s%n%an · %ar" {}' \
			--preview-window='right:50%:wrap' \
		|| true
)"

if [ -z "${selected:-}" ]; then
	exit 1
fi

echo "$selected"
