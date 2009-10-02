#!/bin/bash

curdir="$(dirname "$0")"

# $1 - dir
function is_olx_dir() {
	test -d "$1/build/Xcode/OpenLieroX.xcodeproj" && return 0 || return 1
}

function guess_olx_dir() {
	# We could check several dirs here now. This is just how I have it.
	echo "${curdir}/../openlierox"
}

# $1 - macosx .app bundle
function is_olx_macosx_bin() {
	test -e "$1/Contents/Info.plist" && \
	test -d "$1/Contents/MacOS" && \
	return 0
	# no macosx binary
	return 1
}

# returns olx macosx .app bundle
# optional $1 - olxdir
function get_olx_macosx_bin() {
	if [ "$1" != "" ]; then
		olxdir="$1"
	else
		olxdir="$(guess_olx_dir)"	
	fi
	echo "${olxdir}/build/Xcode/build/Release/OpenLieroX.app"
}

# $1 - binary
function test_olx_bin() {
	"$1" -exec quit || return 1
	return 0
}
