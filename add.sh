#!/bin/sh -u
#
# Copyright (c) 2019, Cristian Ariza
# All rights reserved.

if "$#" -lt 2; then
	exit 1
fi

n="$1" && shift
text="$1" && shift

swp="$(cat "$@")"

# If swp is not empty, add a newline to it
swp="${swp:+"$swp"\\n}"

case "$n" in
"-a") printf '%s%s\n' "$swp" "$text" ;;
0) printf '%s\n%s' "$text" "$swp" ;;
*)
	printf '%s' "$swp" | sed -n 1,"$n"p
	printf '%s\n' "$text"
	printf '%s' "$swp" | sed -n "$((n + 1))",\$p
	;;
esac
