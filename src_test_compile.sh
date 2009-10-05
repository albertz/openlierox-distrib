#!/bin/bash

cd "$(dirname "$0")"
distribdir="$(pwd)"

source functions.sh

rm -rf tmp 2>/dev/null
mkdir  tmp || {
	echo "Could not create tmp directory."
	exit 1
}



rm -rf tmp
