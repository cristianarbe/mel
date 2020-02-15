#!/bin/sh -u
#
# Copyright (c) 2019, Cristian Ariza
# All rights reserved.

if "$#" -lt 2; then
	exit 1
fi

n="$1" && shift
text="$1" && shift

if test "$#" -eq 0; then
	# Input comes from stdin
	swp="$(cat)"
else
	# Input comes from filename
	swp="$(cat "$1")" && shift
fi

case "$n" in
"-a")
	if test -z "$swp"; then
		printf '%s\n' "$text"
	else
		printf '%s\n%s\n' "$swp" "$text"
	fi
	;;
0)
	printf '%s\n%s\n' "$text" "$swp"
	;;
*)
	printf '%s\n' "$swp" | sed -n 1,"$n"p
	printf '%s\n' "$text"
	printf '%s\n' "$swp" | sed -n "$((n + 1))",\$p
	;;
esac
