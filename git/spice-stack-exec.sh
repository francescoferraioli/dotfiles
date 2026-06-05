#!/bin/sh
# Run a command on each branch in a git-spice stack (bottom to top).
#
# Usage:
#   git s-each 'git push -u origin %'
#   git s-each -- git status
#   git s-each -a 'echo %'          # all tracked branches, not just this stack
#   git s-each -n 'git status'      # dry run: list branches only
#
# Placeholders: % (branch name in the command) or $b (exported for eval).
# Spice flags -a / --all are forwarded to git-spice log short.

set -eu

usage() {
	echo "s-each: run a command on each branch in the git-spice stack" >&2
	echo "  git s-each 'git push -u origin %'" >&2
	echo "  git s-each -- git status" >&2
	echo "  git s-each -a 'echo %'" >&2
	echo "  git s-each -n 'git status'" >&2
}

if [ $# -eq 0 ]; then
	usage
	exit 1
fi

spice_args=
dry_run=false

while [ $# -gt 0 ]; do
	case "$1" in
		-a|--all)
			spice_args="$spice_args $1"
			shift
			;;
		-n|--dry-run)
			dry_run=true
			shift
			;;
		--)
			shift
			break
			;;
		-*)
			echo "s-each: unknown option $1" >&2
			usage
			exit 1
			;;
		*)
			break
			;;
	esac
done

if [ $# -eq 0 ]; then
	usage
	exit 1
fi

if [ $# -eq 1 ]; then
	cmd=$1
else
	echo "s-each: quote the command or use -- before it" >&2
	usage
	exit 1
fi

if ! git rev-parse --git-dir >/dev/null 2>&1; then
	echo "s-each: not a git repository" >&2
	exit 1
fi

if ! command -v git-spice >/dev/null 2>&1; then
	echo "s-each: git-spice not found" >&2
	exit 1
fi

original="$(git branch --show-current 2>/dev/null || true)"

restore_branch() {
	if [ -n "${original:-}" ]; then
		git checkout "$original" >/dev/null 2>&1 || true
	fi
}

if [ "$dry_run" = false ] && [ -n "$original" ]; then
	trap restore_branch EXIT
fi

branches="$(
	# shellcheck disable=SC2086
	git-spice log short --json $spice_args 2>&1 \
		| python3 -c '
import json
import sys

branches = {}
for line in sys.stdin:
    line = line.strip()
    if not line or not line.startswith("{"):
        continue
    branch = json.loads(line)
    branches[branch["name"]] = branch

if not branches:
    sys.exit(1)

names = set(branches)
bottoms = sorted(
    name
    for name, branch in branches.items()
    if not branch.get("down") or branch["down"]["name"] not in names
)

order = []

def walk(name):
    if name in order:
        return
    order.append(name)
    for up in branches.get(name, {}).get("ups", []):
        walk(up["name"])

for bottom in bottoms:
    walk(bottom)

for name in order:
    print(name)
'
)" || branches=""

if [ -z "$branches" ]; then
	echo "s-each: no git-spice stack branches found (are you in a spice-tracked repo?)" >&2
	exit 1
fi

failures=0

while IFS= read -r branch; do
	[ -n "$branch" ] || continue

	printf '=====================\n%s\n=====================\n' "$branch"

	if [ "$dry_run" = true ]; then
		continue
	fi

	if ! git checkout "$branch" >/dev/null 2>&1; then
		echo "s-each: could not check out $branch" >&2
		failures=$((failures + 1))
		continue
	fi

	export b="$branch"
	escaped_branch="$(printf '%s' "$branch" | sed 's/[\\&|]/\\&/g')"
	run_cmd="$(printf '%s\n' "$cmd" | sed "s|%|${escaped_branch}|g")"

	if ! eval "$run_cmd"; then
		echo "s-each: command failed on $branch" >&2
		failures=$((failures + 1))
	fi
done <<-BRANCHES
$branches
BRANCHES

if [ "$failures" -gt 0 ]; then
	exit 1
fi
