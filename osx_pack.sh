#!/bin/bash

cd "$(dirname "$0")"
distribdir="$(pwd)"

source functions.sh

olxdir="$(guess_olx_dir)"

if ! is_olx_dir "$olxdir"; then
	echo "Cannot find openlierox dir. Fix functions.sh."
	exit 1
fi

"${distribdir}"/osx_build.sh || {
	echo "Error while building."
	exit 1	
}

olxbin="$(get_olx_macosx_bin)"

"${distribdir}"/osx_test_binary.sh "$olxbin" || {
	echo "Error while testing binary."
	exit 1
}


# builds a DMG for OpenLieroX

# Creates a disk image (dmg) on Mac OS X from the command line.
# usage:
#    mkdmg <volname> <dmgname> <srcdir>
#
# Where <volname> is the name to use for the mounted image, <vers> is the version
# number of the volume and <srcdir> is where the contents to put on the dmg are.
#
# The result will be a file called <dmgname>.dmg
mkdmg() {

	if [ $# != 3 ]; then
		echo "usage: mkdmg volname dmgname srcdir"
		exit 1
	fi
	
	VOL="$1"
	DMG="$2"
	FILES="$3"
	DMGTMP="tmp-$DMG"

	if [ "$(echo "$DMG" | grep ".dmg")" == "" ]; then
		echo "mkdmg: dmg-filename $DMG is invalid, must have .dmg ending"
		exit 1
	fi

	# create temporary disk image and format, ejecting when done
	SIZE=$(du -sk ${FILES} | cut -f 1)
	SIZE=$((${SIZE}/1000+5))
	hdiutil create "$DMGTMP" -megabytes ${SIZE} -ov -type UDIF -fs HFS+ -volname "$VOL" || {
		echo "mkdmg: could not create temp dmg"
		exit 1
	}

	# mount and copy files onto volume
	hdid "$DMGTMP" || {
		echo "mkdmg: could not mount temp dmg"
		exit 1
	}
	echo -n "copying files ... "
	cp -R "${FILES}"/* "/Volumes/$VOL/" || {
		echo "mkdmg: error while copying files"
		exit 1
	}
	echo "ready"
	hdiutil eject "/Volumes/$VOL"

	# convert to compressed image, delete temp image
	rm -f "$DMG"
	hdiutil convert "$DMGTMP" -format UDZO -o "$DMG" || {
		echo "mkdmg: error while creating compressed dmg"
		exit 1
	}
	rm -f "$DMGTMP"
}

mkdir -p dmg || {
	echo "Cannot create temporary dmg directory."
	exit 1
}

olxtargetname="$(get_olx_targetname)"

echo "** preparing release DMG"
mkdir -p "dmg/OpenLieroX.app"
rsync -a --delete "$olxbin/"* "dmg/OpenLieroX.app" || {
	echo "osx_pack: error while copying binary"
	exit 1
}
mkdmg "$olxtargetname" "$(get_olx_osx_fn)" dmg || {
	echo "osx_pack: error while creating DMG"
	exit 1
}
rm -rf dmg

echo "** ready"
