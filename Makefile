#!/bin/bash
case $1 in
  install)
    if [[ "$EUID" != 0 ]]; then
      echo "Please run as root"
      exit
	else
	  cp mel /bin/
    fi
  ;;
esac
