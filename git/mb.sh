#!/bin/sh
# Resolve the repository's main/base branch name (without origin/ prefix).
# Prefers origin/HEAD; falls back to develop, main, master.
#
# Usage: git mb

set -eu

branch="$(git symbolic-ref -q --short refs/remotes/origin/HEAD 2>/dev/null | sed 's|^origin/||' || true)"

if [ -z "$branch" ]; then
	for cand in develop main master; do
		if git show-ref --verify --quiet "refs/remotes/origin/$cand"; then
			branch=$cand
			break
		fi
	done
fi

if [ -z "$branch" ]; then
	echo 'mb: no base branch found (no origin/HEAD and no origin/develop|main|master)' >&2
	exit 1
fi

echo "$branch"
