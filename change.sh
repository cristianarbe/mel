#!/bin/sh -u
#
# Copyright (c) 2019, Cristian Ariza
# All rights reserved.

{
	case "$#" in
	2) cat | add "$@" ;; # Input comes from stdin
	3) add "$@" ;;       # Input comes from filename
	*) exit 1 ;;
	esac
} | sed "$1"d
