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
	"-n") tail -n 1 "$SWAP" ;;
	*) sed -n "$1"p "$SWAP" ;;
	esac
}

change(){ add "$@" | sed "$1"d; }

# Processes user commands
meleval() {
	cmd="$1" && shift
	case "$cmd" in
	':a' | ':c')
		if test "$#" -ge 1; then
			n="$1" && shift
		fi

		case "$cmd" in
		c) cmd="change" ;;
		*) cmd="add" ;;
		esac

		# If n is empty or unset, use -n as its value.
		_print "${n:-'-n'}"
		cat "$SWAP" > "$BKP"
		"$cmd" "${n:-'-n'}" "$(cat)" "$BKP" > "$SWAP"
		;;
	':d') sed -i "$1"d "$SWAP" ;; # Deletes a line
	':e')
		# Edit another file
		mv "$SWAP" "$BKP"
		exec "$0" "$@"
		;;
	':f') printf '%s/%s\n' "$(pwd)" "$ORIG" ;; # Shows path of current file
	':p') _print "$@" ;;
	':q') exit 0 ;;
	':w' | ':wq') cat "$SWAP" > "$ORIG" ;; # Saves the file
	u) cat "$BKP" > "$SWAP" ;; # Undoes last change
	/) grep -n "$@" "$SWAP" ;;
	!) "$@" ;; # Shell commands
	*) printf "The %s command is unknown\\n" "$cmd" ;;
	esac

	case "$cmd" in
	':q' | ':wq' ) exit 0 ;;
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
	read -r input
	if test "${#input}" -eq 1; then
		continue
	fi

	eval "set -- $input"
	meleval "$@"
done