#!/bin/sh
# Pick a branch (via git sb) and run a command with that branch substituted in.
# Placeholders: % (replaced in the command string) or $b (exported for eval).
#
# Usage:
#   git sbe 'git rebase %'
#   git sbe 'git log $b..HEAD'
#   git sbe my-branch 'git rebase %'
#   git sbe -- git rebase %

set -eu

usage() {
	echo "sbe: pick a branch, then run a command (% or \$b = branch)" >&2
	echo "  git sbe 'git rebase %'" >&2
	echo "  git sbe 'git log \$b..HEAD'" >&2
	echo "  git sbe my-branch 'git rebase %'" >&2
	echo "  git sbe -- git rebase %" >&2
}

if [ $# -eq 0 ]; then
	usage
	exit 1
fi

branch=""
cmd=""

if [ "$1" = "--" ]; then
	shift
	if [ $# -eq 0 ]; then
		exit 0
	fi
	branch="$(git sb)"
	cmd=$*
elif [ $# -eq 1 ]; then
	branch="$(git sb)"
	cmd=$1
elif [ $# -eq 2 ]; then
	branch="$(git sb "$1")"
	cmd=$2
else
	echo "sbe: quote the command or use -- before it" >&2
	usage
	exit 1
fi

if [ -z "$branch" ]; then
	exit 0
fi

export b="$branch"

escaped_branch="$(printf '%s' "$branch" | sed 's/[\\&|]/\\&/g')"
cmd="$(printf '%s\n' "$cmd" | sed "s|%|${escaped_branch}|g")"

eval "$cmd"
