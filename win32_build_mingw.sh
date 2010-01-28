#!/bin/bash

distribdir="$(dirname "$0")"
cd "${distribdir}"

source functions.sh

olxdir="$(guess_olx_dir)"
distribdir="$(pwd)"

mkdir -p win32build
cd win32build

mingwdir="${distribdir}/mingw"

cprefix="/usr/bin/i586-mingw32"
export CC="${cprefix}-gcc"
export CXX="${cprefix}-c++"

CFLAGS="$CFLAGS -I${mingwdir}/include"
CFLAGS="$CFLAGS -I${mingwdir}/include/SDL -DMINGW"
export CFLAGS
export CXXFLAGS="$CFLAGS"



mv "${olxdir}/CMakeCache.txt" "${olxdir}/CMakeCache.txt.old" 2>/dev/null
cachemoved=$?

cmake \
	-D CMAKE_C_COMPILER="$CC" \
	-D CMAKE_CXX_COMPILER="$CXX" \
	-D MINGW_CROSS_COMPILE=1 \
	-D LINKER_LANGUAGE="CXX" \
	-D BREAKPAD=0 \
	-D CMAKE_EXE_LINKER_FLAGS="-L${mingwdir}/lib -u _WinMain@16 -static-libgcc -mwindows" \
	"${olxdir}"
cmakerun=$?

[ "$cachemoved" = "0" ] && mv "${olxdir}/CMakeCache.txt.old" "${olxdir}/CMakeCache.txt"

[ "$cmakerun" != "0" ] && echo "cmake failed" && exit 1

make -j4
