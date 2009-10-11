#!/bin/bash

if [ "$1" = "" ]; then
	echo "usage: $0 <olxversion>"
	echo "example: $0 0.58_beta4"
	exit 1
fi

newversion="$1"

cd "$(dirname "$0")"

source functions.sh

olxdir="$(guess_olx_dir)"

if ! is_olx_dir "$olxdir"; then
        echo "Cannot find openlierox dir. Fix functions.sh."
        exit 1
fi

cd "$olxdir"

echo "* Old version: $(cat VERSION)"
echo "* Setting new version to: $newversion"

# VERSION file
echo "$newversion" > VERSION

# source Version.cpp
sed -i -r -e "s/LX_VERSION.*\".*\"/LX_VERSION\t\"$newversion\"/1" src/common/Version.cpp

# Debian
sed -i -e "s/openlierox (.*)/openlierox ($(get_deb_olx_ver "$newversion"))/1" \
-e "s/-- Albert Zeyer .*/-- Albert Zeyer <albert.zeyer@rwth-aachen.de>  $(date -R)/1" debian/changelog
