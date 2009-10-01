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
