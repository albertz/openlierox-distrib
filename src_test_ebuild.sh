#!/bin/bash

cd "$(dirname "$0")"
distribdir="$(pwd)"

source functions.sh

eb="openlierox-$(get_olx_version).ebuild"
eb="${distribdir}/ebuild/games-action/openlierox/${eb}"

if [ ! -e $eb ]; then
	echo "Ebuild $(basename $eb) not found."
	exit 1
fi
