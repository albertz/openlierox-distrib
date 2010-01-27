#!/bin/bash

distribdir="$(dirname "$0")"
cd "${distribdir}"

source functions.sh

olxdir="$(guess_olx_dir)"

mkdir -p win32build
cd win32build

mingwdir="${distribdir}/mingw"

export CC="i586-mingw32msvc-cc"
export CXX="i586-mingw32msvc-c++"

export CFLAGS="-I\"${mingwdir}/include\""
export CXXFLAGS="$CFLAGS"

#	-D CMAKE_EXE_LINKER_FLAGS="-L\\\\\\\"${mingwdir}/lib\\\\\\\" -u _WinMain@16" \


mv "${olxdir}/CMakeCache.txt" "${olxdir}/CMakeCache.txt.old" 2>/dev/null
cachemoved=$?

cmake \
	-D MINGW_CROSS_COMPILE=1 -D BREAKPAD=0 \
	-D LINKER_LANGUAGE="CXX" \
	"${olxdir}"
cmakerun=$?

[ "$cachemoved" = "0" ] && mv "${olxdir}/CMakeCache.txt.old" "${olxdir}/CMakeCache.txt"

[ "$cmakerun" != "0" ] && echo "cmake failed" && exit 1

make -j4 VERBOSE=1
