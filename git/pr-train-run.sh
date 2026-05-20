#!/bin/sh
# Usage: pr-train-run.sh <prt|prtd> [bn] <specifier> [extra args...]
#   git prt bn 2     → git pr-train --branch-name 1
#   git prt next     → git pr-train next
# Extra arguments after the specifier are passed through unchanged.
# Rebase onto train branches: git prtr [-i] (see pr-train-rebase.sh)

DOTFILES="${DOTFILES:-$HOME/dotfiles}"

normalize() {
    sh "$DOTFILES/git/pr-train-arg.sh" "$1"
}

mode="$1"
shift

case "$(printf '%s' "${1:-}" | tr '[:upper:]' '[:lower:]')" in
    bn)
        shift
        normalized="$(normalize "$1")"
        shift
        set -- --branch-name "$normalized" "$@"
        ;;
    *)
        normalized="$(normalize "$1")"
        shift
        set -- "$normalized" "$@"
        ;;
esac

case "$mode" in
    prt) exec git pr-train "$@" ;;
    prtd) exec "$HOME/canvanauts/realyze-git-pr-train/dist/index.js" "$@" ;;
    *)
        echo "pr-train-run: unknown mode $mode" >&2
        exit 1
        ;;
esac
