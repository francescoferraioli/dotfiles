#!/usr/bin/env bash
# Run after a commit on ff-canva in the dotfiles repo: delegates to canva/master-resync.sh.
# Usage: post-commit-resync.sh [REPO_ROOT]
#   REPO_ROOT  optional git checkout root (defaults to cwd repo via git rev-parse).

set -euo pipefail

_skill_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
_dotfiles="$(cd "${_skill_dir}/../../.." && pwd)"
_dotfiles_root="$(git -C "$_dotfiles" rev-parse --show-toplevel)"
_master_resync="${_dotfiles}/canva/master-resync.sh"

if [[ ! -f "$_master_resync" ]]; then
	echo "post-commit-resync: missing ${_master_resync}" >&2
	exit 1
fi

if [[ $# -ge 1 ]]; then
	_repo="$(cd "$1" && git rev-parse --show-toplevel)"
else
	_repo="$(git rev-parse --show-toplevel)"
fi

if [[ "$_repo" != "$_dotfiles_root" ]]; then
	echo "post-commit-resync: cwd or first arg must be this dotfiles repo (expected ${_dotfiles_root}, got ${_repo})" >&2
	exit 1
fi

cd "$_repo"

_current="$(git branch --show-current)"
if [[ "$_current" != "ff-canva" ]]; then
	echo "post-commit-resync: not on ff-canva (current: ${_current})" >&2
	exit 1
fi

bash "$_master_resync"
