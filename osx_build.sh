#!/bin/bash

distribdir="$(dirname "$0")"
cd "${distribdir}"

source functions.sh

olxdir="$(guess_olx_dir)"

if ! is_olx_dir "$olxdir"; then
	echo "Cannot find openlierox dir. Fix functions.sh."
	exit 1
fi

cd "${olxdir}/build/Xcode"

xcodebuild -target OpenLieroX -configuration Release

