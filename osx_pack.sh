#!/bin/bash

cd "$(dirname "$0")"
distribdir="$(pwd)"

source functions.sh

olxdir="$(guess_olx_dir)"

if ! is_olx_dir "$olxdir"; then
	echo "Cannot find openlierox dir. Fix functions.sh."
	exit 1
fi

cd "${olxdir}/build/Xcode"

"${distribdir}"/osx_fix_binary.sh
