#!/bin/sh
# Normalizes a pr-train branch specifier for git prt / git prtd:
#   previous | next | combined → pass through (no leading dash)
#   numeric → decrement by 1 (git prt 2 → 1)
#   otherwise → prefix with - (git prt foo → -foo)

arg="$1"

case "$(printf '%s' "$arg" | tr '[:upper:]' '[:lower:]')" in
    previous|next|combined|first|last)
        printf '%s' "$(printf '%s' "$arg" | tr '[:upper:]' '[:lower:]')"
        ;;
    '')
        printf '%s' '-'
        ;;
    *)
        if [ -n "$arg" ] && [ "$arg" -eq "$arg" ] 2>/dev/null; then
            printf '%s' "$((arg - 1))"
        else
            printf '%s' "-$arg"
        fi
        ;;
esac
