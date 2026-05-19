#!/bin/sh
# Normalizes args for git prt / git prtd:
#   numeric → decrement by 1 (git prt 2 → pass 1)
#   otherwise → prefix with - (git prt foo → pass -foo)
arg="$1"
if [ -n "$arg" ] && [ "$arg" -eq "$arg" ] 2>/dev/null; then
	arg=$((arg - 1))
else
	arg="-$arg"
fi
printf '%s' "$arg"
