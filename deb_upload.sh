#!/bin/bash

cd "$(dirname "$0")"
distribdir="$(pwd)"

source functions.sh

olxdir="$(guess_olx_dir)"

if ! is_olx_dir "$olxdir"; then
	echo "Cannot find openlierox dir. Fix functions.sh."
	exit 1
fi

uploaded=false

for ARCH in i386 ia64 amd64; do
	if [ -e "$olxdir/../$(get_olx_deb_${ARCH}_fn)" ]; then 
		upload_to_frs "$olxdir/../$(get_olx_deb_${ARCH}_fn)"
		uploaded=true
	fi
done

if ! $uploaded ; then
	echo No debian package was uploaded
fi
