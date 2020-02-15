#!/bin/sh -u
#
# Copyright (c) 2019, Cristian Ariza
# All rights reserved.
#
# Ed-like text editor in POSIX shell

###########
# Functions
###########

_print() {
	case "$#" in
	0)
		i=1
		while read -r line; do
			printf '%s | %s\n' "$i" "$line"
			i=$((i + 1))
		done < "$SWAP"
		echo 'EOF'
		;;
	*) sed -n "$1"p "$SWAP" ;;
	esac
}

# Processes user commands
parse() {
	if test "$#" -lt 1; then
		return 0
	fi

	cmd="$1" && shift
	case "$cmd" in
	p) _print "$@" ;;
	/) grep -n "$@" "$SWAP" ;;
	a | c)
		case "$cmd" in
		c) cmd="change" ;;
		a) cmd="add" ;;
		esac

		case "$#" in
		0)
			n='-a'
			tail -n 1 "$SWAP"
			;;
		1)
			n="$1" && shift
			sed -n "$n"p "$SWAP"
			;;
		esac

		cat "$SWAP" > "$BKP"
		"$cmd" "$n" "$(cat)" "$BKP" > "$SWAP"
		;;
	!) "$@" ;; # Shell commands
	d) sed -i "$1"d "$SWAP" ;; # Deletes a line
	w) cat "$SWAP" > "$ORIG" ;; # Saves the file
	wq)
		# Saves and exits
		cat "$SWAP" > "$ORIG"
		exit 0
		;;
	u) cat "$BKP" > "$SWAP" ;; # Undoes last change
	q) exit 0 ;;
	e)
		# Edit another file
		mv "$SWAP" "$BKP"
		exec "$0" "$@"
		;;
	f) printf '%s/%s\n' "$(pwd)" "$ORIG" ;; # Shows path of current file
	*) printf "The %s command is unknown\\n" "$cmd" ;;
	esac
}

usage="mel v0.0.1 (C) Cristian Ariza
	
usage: %s [OPTIONS] [FILE]

	-H  List available features"

# Disables Ctrl+C
trap '' 2

DIR="$(
	cd "$(dirname "$0")" || exit 1
	pwd
)"
PREFIX="$DIR"/..
export PATH="$PREFIX"/lib/mel:"$PATH"

if test "$#" -ne 1 || test "$1" = "--help" || test ! -f  "$1"; then
	printf "%s\\n" "$usage"
	exit 1
fi

ORIG="$1"
SWAP=."$1".melswp
BKP=."$1".melbkp
cat "$ORIG" > "$SWAP"

trap 'rm "$SWAP"' EXIT

while true; do
	printf ":" && read -r input
	eval "set -- $input"
	parse "$@"
done
