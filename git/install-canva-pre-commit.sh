#!/bin/sh
# Idempotently append a canva-taz-fmt call to Canva's local pre-commit hook.
#
# Usage:
#   install-canva-pre-commit.sh [path-to-canva-repo]
# Default: $HOME/work/canva
#
# Skips (exit 0) when the directory is missing or origin is not Canva/canva.
# Appends only; never overwrites an existing hook body.

set -eu

MARKER='canva-scripts: taz-fmt'
CALL_LINE='canva-taz-fmt || exit $?'
repo="${1:-$HOME/work/canva}"

log() {
	printf 'install-canva-pre-commit: %s\n' "$1"
}

if [ ! -d "$repo" ]; then
	log "skipping: $repo does not exist"
	exit 0
fi

if ! git -C "$repo" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
	log "skipping: $repo is not a git work tree"
	exit 0
fi

origin="$(git -C "$repo" remote get-url origin 2>/dev/null || true)"
case "$origin" in
	*github.com[:/]Canva/canva*)
		;;
	*)
		log "skipping: origin is not Canva/canva (${origin:-none})"
		exit 0
		;;
esac

hooks_dir="$(git -C "$repo" rev-parse --git-common-dir)/hooks"
# git may return a relative git-common-dir; resolve against the repo
case "$hooks_dir" in
	/*) ;;
	*) hooks_dir="$repo/$hooks_dir" ;;
esac

mkdir -p "$hooks_dir"
pre_commit="$hooks_dir/pre-commit"

if [ ! -f "$pre_commit" ]; then
	printf '%s\n' '#!/bin/sh' >"$pre_commit"
	chmod +x "$pre_commit"
	log "created $pre_commit"
fi

if grep -qF "$MARKER" "$pre_commit"; then
	log "already installed in $pre_commit"
	exit 0
fi

if ! command -v canva-taz-fmt >/dev/null 2>&1; then
	log "warning: canva-taz-fmt not on PATH (ensure scripts is on PATH before commits)"
fi

{
	printf '\n'
	printf '# %s\n' "$MARKER"
	printf '%s\n' "$CALL_LINE"
} >>"$pre_commit"

log "appended $CALL_LINE to $pre_commit"
