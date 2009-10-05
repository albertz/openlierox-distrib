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

function get_olx_version() {
	[ "$olxdir" = "" ] && olxdir="$(guess_olx_dir)"
	cat "$olxdir/VERSION"
}

function get_olx_human_version() {
	get_olx_version | tr "_" " "
}

function get_olx_targetname() {
	echo "OpenLieroX $(get_olx_human_version)"
}

function guess_sfuser() {
	[ "$sfuser" != "" ] && echo "$sfuser" && return 0
	[ "$(whoami)" == "az" ] && echo "albertzeyer,openlierox" && return 0
	[ "$(hostname | grep "albert")" != "" ] && echo "albertzeyer,openlierox" && return 0

	[ "$(whoami)" == "pelya" ] && echo "pelya,openlierox" && return 0

	# add more checks for yourself here
	echo "WASNOTABLETODETYOURSFUSERNAME"
}

function upload_to_frs() {
	[ ! -e "$1" ] && {
		echo "upload_to_frs: $1 not found"
		return 1
	}

	[ "$sfuser" = "" ] && sfuser="$(guess_sfuser)"
	[ "$group" = "" ] && group="openlierox"
	[ "$release" = "" ] && release="OpenLieroX $(get_olx_human_version)"

	echo "* creating interactive SF shell"
	ssh $sfuser@shell.sourceforge.net create

	echo "* uploading $(basename $1) to $group / $release ..."
	rsync -vP "$1" \
	$sfuser@shell.sourceforge.net:"\"/home/frs/project/o/op/openlierox/$group/$release/\""
}

function get_olx_basefn() {
	echo "OpenLieroX_$(get_olx_version)"
}

function get_olx_osx_fn() {
	echo "$(get_olx_basefn).mac.dmg"
}

function get_olx_win32_fn() {
	echo "$(get_olx_basefn).win32.zip"
}

function get_olx_win32patch_fn() {
	echo "$(get_olx_basefn).win32.patch.zip"
}

function get_olx_win32debug_fn() {
	echo "$(get_olx_basefn).win32.debug.zip"
}

function get_olx_src_fn() {
	echo "$(get_olx_basefn).src.tar.bz2"
}

function get_olx_deb_i386_fn() {
	echo "openlierox_`echo $(get_olx_version)|sed 's/_/./g'`_i386.deb"
}

function get_olx_deb_amd64_fn() {
	echo "openlierox_`echo $(get_olx_version)|sed 's/_/./g'`_amd64.deb"
}

function get_olx_deb_ia64_fn() {
	echo "openlierox_`echo $(get_olx_version)|sed 's/_/./g'`_ia64.deb"
}


# ------- some system functions ----

function is_gentoo() {
	type ebuild 2>/dev/null >/dev/null && return 0
	return 1
}
