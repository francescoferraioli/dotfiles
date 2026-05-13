#!/usr/bin/env bash
# Promote commits from ff-canva onto the main branch (git mb), then rebuild ff-canva.
#
# Invariant: the oldest commit on ff-canva after origin/$(git mb) is your *personal*
# (local-only) commit; every commit above that is shared work to cherry-pick onto mb.
#
# Requires: clean working tree, currently on ff-canva.
# Optional: MASTER_RESYNC_REPO_ROOT points at the Canva checkout when this file is
# invoked from elsewhere (e.g. dotfiles/.claude/skills/commit/post-commit-resync.sh).

set -euo pipefail

# When set (e.g. by dotfiles/.claude/skills/commit/post-commit-resync.sh), use this
# checkout instead of inferring repo root from this file's path under canva/.
if [[ -n "${MASTER_RESYNC_REPO_ROOT:-}" ]]; then
	REPO_ROOT="$(cd "$MASTER_RESYNC_REPO_ROOT" && git rev-parse --show-toplevel)"
else
	REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && git rev-parse --show-toplevel)"
fi
cd "$REPO_ROOT"

if ! git rev-parse --verify ff-canva >/dev/null 2>&1; then
	echo "master-resync: branch ff-canva does not exist" >&2
	exit 1
fi

MB="$(git mb)"
REMOTE_MB="origin/$MB"

git fetch origin

CURRENT="$(git branch --show-current)"
if [[ "$CURRENT" != "ff-canva" ]]; then
	echo "master-resync: must be on ff-canva (current: $CURRENT)" >&2
	exit 1
fi

if ! git diff --quiet || ! git diff --cached --quiet; then
	echo "master-resync: working tree is not clean; commit or stash first" >&2
	exit 1
fi

MERGE_BASE="$(git merge-base "$REMOTE_MB" ff-canva)"
AHEAD_COUNT="$(git rev-list --count "$MERGE_BASE"..ff-canva)"

if [[ "$AHEAD_COUNT" -eq 0 ]]; then
	echo "master-resync: ff-canva is not ahead of $REMOTE_MB; nothing to do" >&2
	exit 0
fi

P="$(git log "$MERGE_BASE"..ff-canva --reverse --format=%H | head -1)"
SHARED_COUNT="$((AHEAD_COUNT - 1))"

git switch "$MB" 2>/dev/null || git switch -c "$MB" --track "$REMOTE_MB"
git pull --ff-only

if [[ "$SHARED_COUNT" -gt 0 ]]; then
	git cherry-pick "${P}"..ff-canva
fi

git push origin "$MB"

git switch ff-canva
git reset --hard "$REMOTE_MB"
git cherry-pick "$P"

git push --force-with-lease origin ff-canva

echo "master-resync: done. ff-canva is $REMOTE_MB plus your personal commit."
