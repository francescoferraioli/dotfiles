#!/bin/sh
# s-fmar: sync with remote, remove merged spice branches repo sync missed, restack.
#
# Handles squash/rebase merges where gs repo sync cannot correlate local history
# with the merged change request. Uses git-spice CR status, not commit ancestry.
#
# Usage:
#   git s-fmar
#   git s-fmar -n
#   git s-fmar --dry-run

set -eu

dry_run=false
spice_json=
needs_restore=false

usage() {
	printf 's-fmar: sync, remove merged stack branches, restack\n' >&2
	printf '  git s-fmar [-n|--dry-run]\n' >&2
}

log() {
	printf 's-fmar: %s\n' "$1"
}

fail() {
	printf 's-fmar: %s\n' "$1" >&2
	exit 1
}

restore_branch() {
	if [ -n "${original:-}" ] && git show-ref --verify --quiet "refs/heads/$original"; then
		if ! git checkout "$original" >/dev/null 2>&1; then
			printf 's-fmar: warning: could not restore branch %s\n' "$original" >&2
		fi
	fi
}

cleanup() {
	rm -f "${spice_json:-}"
	spice_json=
	if [ "$needs_restore" = true ]; then
		needs_restore=false
		restore_branch
	fi
}

while [ $# -gt 0 ]; do
	case "$1" in
		-n|--dry-run)
			dry_run=true
			shift
			;;
		-h|--help)
			usage
			exit 0
			;;
		--)
			shift
			break
			;;
		-*)
			fail "unknown option $1 (try -n/--dry-run)"
			;;
		*)
			fail "unexpected argument $1"
			;;
	esac
done

if [ $# -gt 0 ]; then
	fail "unexpected argument $1"
fi

if ! git rev-parse --git-dir >/dev/null 2>&1; then
	fail 'not a git repository'
fi

if ! command -v git-spice >/dev/null 2>&1; then
	fail 'git-spice not found'
fi

if [ "$dry_run" = false ] && [ -n "$(git status --porcelain)" ]; then
	fail 'working tree is not clean; commit or stash changes first'
fi

original="$(git branch --show-current 2>/dev/null || true)"
trap cleanup EXIT INT TERM HUP

if [ "$dry_run" = false ]; then
	log 'syncing repository (restack=none)...'
	if ! git-spice repo sync --restack=none; then
		fail 'repo sync failed'
	fi
else
	log 'dry run: skipping repo sync'
fi

log 'checking stack for merged change requests...'
spice_json="$(mktemp)"

if ! git-spice log short --json --cr-status=true >"$spice_json"; then
	fail 'failed to list stack branches (git-spice log short)'
fi

if ! parse_output="$(python3 -c '
import json
import sys

branches = {}
for line in sys.stdin:
    line = line.strip()
    if not line:
        continue
    if not line.startswith("{"):
        print(f"unexpected non-JSON line from git-spice: {line}", file=sys.stderr)
        sys.exit(1)
    try:
        branch = json.loads(line)
    except json.JSONDecodeError as exc:
        print(f"invalid JSON from git-spice: {exc}", file=sys.stderr)
        sys.exit(1)
    if "name" not in branch:
        print("JSON object missing required field: name", file=sys.stderr)
        sys.exit(1)
    branches[branch["name"]] = branch

names = set(branches)
bottoms = sorted(
    name
    for name, branch in branches.items()
    if not branch.get("down") or branch["down"]["name"] not in names
)

order = []

def walk(name, skip_self=False):
    if not skip_self:
        if name in order:
            return
        order.append(name)
    for up in branches.get(name, {}).get("ups", []):
        walk(up["name"])

for bottom in bottoms:
    walk(bottom, skip_self=True)

for name in order:
    change = branches[name].get("change") or {}
    if change.get("status") == "merged":
        print(f"merged:{name}")

survivor = None
for name in reversed(order):
    change = branches[name].get("change") or {}
    if change.get("status") != "merged":
        survivor = name
        break

if survivor:
    print(f"survivor:{survivor}")
' <"$spice_json")"; then
	fail 'failed to parse git-spice JSON output'
fi

merged_branches=
survivor=

while IFS= read -r line; do
	case "$line" in
		merged:*)
			branch="${line#merged:}"
			merged_branches="$merged_branches${merged_branches:+
}$branch"
			;;
		survivor:*)
			survivor="${line#survivor:}"
			;;
	esac
done <<-PARSED
$parse_output
PARSED

set --
while IFS= read -r branch; do
	[ -n "$branch" ] || continue
	set -- "$@" "$branch"
done <<-MERGED
$merged_branches
MERGED

if [ "$#" -eq 0 ]; then
	log 'no merged branches to remove'
	if [ "$dry_run" = true ]; then
		log 'dry run: would run git-spice repo restack'
		exit 0
	fi
	log 'restacking all tracked branches...'
	if ! git-spice repo restack; then
		fail 'repo restack failed'
	fi
	log 'done'
	exit 0
fi

log 'found merged branches to remove (bottom to top):'
for branch in "$@"; do
	printf '  %s\n' "$branch"
done

if [ "$dry_run" = true ]; then
	log 'dry run: would run:'
	printf '  git-spice branch delete --force --restack=upstack'
	for branch in "$@"; do
		printf ' %s' "$branch"
	done
	printf '\n'
	log 'dry run: would run git-spice repo restack'
	exit 0
fi

if [ -n "$original" ] && printf '%s\n' "$merged_branches" | grep -qxF "$original"; then
	if [ -n "$survivor" ]; then
		needs_restore=true
		log "current branch $original is merged; checking out $survivor for cleanup"
		git checkout "$survivor" >/dev/null 2>&1 \
			|| fail "could not check out survivor branch $survivor"
	else
		fail "current branch $original is merged and no non-merged stack branch is available"
	fi
fi

log 'deleting merged branches in one invocation (restack=upstack)...'
if ! git-spice branch delete --force --restack=upstack "$@"; then
	fail 'branch delete failed'
fi

log 'restacking all tracked branches...'
if ! git-spice repo restack; then
	fail 'repo restack failed'
fi

log 'done'
exit 0
