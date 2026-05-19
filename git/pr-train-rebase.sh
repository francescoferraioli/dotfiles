#!/bin/sh
# Rebase current branch onto a train branch (resolved via prt bn → prTrainArg → pr-train).
# Usage: pr-train-rebase.sh [-i] [prtd] [specifier]
#   git prtr           → git rebase onto previous
#   git prtr -i next   → git rebase -i onto next
#   git prtrd -i 2     → dev pr-train, onto index 1

interactive=
mode=prt
specifier=

while [ $# -gt 0 ]; do
    case "$1" in
        -i)
            interactive=-i
            ;;
        prtd)
            mode=prtd
            ;;
        *)
            specifier="$1"
            ;;
    esac
    shift
done

specifier="${specifier:-previous}"
onto="$(git "$mode" bn "$specifier")"

if [ -n "$interactive" ]; then
    exec git rebase -i "$onto"
fi
exec git rebase "$onto"
