#!/usr/bin/env sh
#
# BSD 3-Clause License
#
# Copyright (c) 2020, Cristian Ariza
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its
#    contributors may be used to endorse or promote products derived from
#    this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# Ed-like text editor in POSIX shell

set -eu

# _insert_line(text, n)
# Inserts text into the line number n of _backup_file and returns the result.
# For n = -1 it inserts it at the end of the file.
_insert_line() {
	_text="$1"
	_n="$2"

	case "$_n" in
	-1)
		cat "$_backup_file"
		printf '%s\n' "$_text"
		;;
	0)
		printf '%s\n' "$_text"
		cat "$_backup_file"
		;;
	*)
		sed -n 1,"$_n"p "$_backup_file"
		printf '%s\n' "$_text"
		sed -n "$((_n + 1))",\$p "$_backup_file"
		;;
	esac
}

# _print_file
# Prints working_file with line numbering
_print_file() {
	_i=1
	while read -r line || [ -n "$line" ]; do
		echo going to print line "$_i" wich contains "$line"
		printf '%s | %s\n' "$_i" "$line"
		_i="$((_i + 1))"
	done <"$_working_file"
	echo 'EOF'
}

# _print_line(n)
# Prints the line number n of _working_file. If n = -1 it prints the last line.
_print_line() {
	case "$1" in
	-1) tail -n 1 "$_working_file" ;;
	*) sed -n "$1"p "$_working_file" ;;
	esac
}

# _replace_line(n)
# Replaces text into the line number n of working_file with n between 1 and the
# total number of lines.
_replace_line() {
	_insert_line "$@" | sed "$1"d
}

# _backup()
# Back up working_file to backup_file
_backup() {
	cat "$_working_file" >"$_backup_file"
}

# _parse_command(cmd)
# Parses user input commands
_parse_command() {
	_cmd="$1" && shift

	case "$_cmd" in
	a)
		_backup
		_n="${1--1}"

		_print_line "$_n"
		_insert_line "$(cat)" "$_n" >"$_working_file"
		;;
	c)
		_backup
		_n="${1--1}"
		_print_line "$_n"
		_replace_line "$(cat)" "$_n" >"$_working_file"
		;;
	d) sed -i "$1"d "$_working_file" ;; # Deletes a line
	*e)                                 # Edit another file
		_backup
		exec "$0" "$@"
		;;
	*w | *wq) cat "$_working_file" >"$_original_file" ;; # Saves the file
	p)
		case "$#" in
		0) _print_file ;;
		1) _print_line "$1" ;;
		esac
		;;
	u) cat "$_backup_file" >"$_working_file" ;; # Undoes last change
	/) grep -n "$1" "$_working_file" ;;
	*!) "$@" ;; # Shell commands
	*q) ;;
	*) printf 'mel: the "%s" command is unknown\n' "$_cmd" ;;
	esac

	case "$_cmd" in
	*q) exit 0 ;;
	esac
}

# disable ctrl + c
# trap '' 2

if [ "$#" -eq 0 ]; then
	printf '%s\n' "$usage"
	exit 1
fi

_original_file="$1"
_working_file=."$1".melswp
_backup_file=."$1".melbkp
_prompt="$(basename "$_original_file")"
_usage="mel v0.0.1 (C) Cristian Ariza
usage: $_prompt [FILE]"

[ ! -f "$_original_file" ] && touch "$_original_file"

cat "$_original_file" >"$_working_file"

trap 'rm -f "$_working_file"' EXIT

while :; do
	printf '%s > ' "$_prompt"
	read -r input

	[ -z "$input" ] && continue

	eval "_parse_command $input"
done
