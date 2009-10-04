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

olxbin="$(get_olx_macosx_bin "$olxdir")"

"${distribdir}"/osx_fix_binary.sh "$olxbin" || {
	echo "Error while fixing binary."
	exit 1
}

"${distribdir}"/osx_test_binary.sh "$olxbin" || {
	echo "Error while testing binary."
	exit 1
}


# builds a DMG for OpenLieroX

# Creates a disk image (dmg) on Mac OS X from the command line.
# usage:
#    mkdmg <volname> <vers> <srcdir>
#
# Where <volname> is the name to use for the mounted image, <vers> is the version
# number of the volume and <srcdir> is where the contents to put on the dmg are.
#
# The result will be a file called <volname>-<vers>.dmg
mkdmg() {

	if [ $# != 2 ]; then
		echo "usage: mkdmg volname srcdir"
		exit 0
	fi

	VOL="$1"
	FILES="$2"

	DMG="tmp-$VOL.dmg"

	# create temporary disk image and format, ejecting when done
	SIZE=$(du -sk ${FILES} | cut -f 1)
	SIZE=$((${SIZE}/1000+5))
	hdiutil create "$DMG" -megabytes ${SIZE} -ov -type UDIF -fs HFS+ -volname "$VOL"

	# mount and copy files onto volume
	hdid "$DMG"
	echo -n "copying files ... "
	cp -R "${FILES}"/* "/Volumes/$VOL/"
	echo "ready"
	hdiutil eject "/Volumes/$VOL"
	#osascript -e "tell application "Finder" to eject disk "$VOL"" && 

	# convert to compressed image, delete temp image
	rm -f "${VOL}.dmg"
	hdiutil convert "$DMG" -format UDZO -o "${VOL}.dmg"
	rm -f "$DMG"

}

mkdir -p dmg || {
	echo "Cannot create temporary dmg directory."
	exit 1
}

olxtargetname="$(get_olx_targetname)"

echo "** preparing release DMG"
mkdir -p "dmg/${olxtargetname}.app"
rsync -a --delete "$olxbin/"* "dmg/${olxtargetname}.app"
mkdmg "$olxtargetname" dmg
rm -rf dmg

echo "** ready"
