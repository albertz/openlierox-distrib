#!/bin/bash

cd "$(dirname "$0")"
distribdir="$(pwd)"

source functions.sh

dmgfile="$(get_olx_osx_fn)"

if [ ! -e "$dmgfile" ]; then
	echo "DMG file $dmgfile not found."
	exit 1
fi

upload_to_frs "$dmgfile"
