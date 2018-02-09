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
which ${cprefix}-gcc || cprefix="/usr/bin/i586-mingw32msvc" # Different name on different Debian variants
which ${cprefix}-gcc || cprefix="/usr/bin/i686-w64-mingw32" # Debian 8
export CC="${cprefix}-gcc"
export CXX="${cprefix}-c++"

CFLAGS="$CFLAGS -I${mingwdir}/include"
CFLAGS="$CFLAGS -I${mingwdir}/include/SDL"
CFLAGS="$CFLAGS -mwin32"
export CFLAGS
export CXXFLAGS="$CFLAGS"



mv "${olxdir}/CMakeCache.txt" "${olxdir}/CMakeCache.txt.old" 2>/dev/null
cachemoved=$?

cmake \
	-D CMAKE_C_COMPILER="$CC" \
	-D CMAKE_CXX_COMPILER="$CXX" \
	-D CMAKE_SYSTEM_NAME="Windows" \
	-D MINGW_CROSS_COMPILE=1 \
	-D BREAKPAD=0 \
	-D DEBUG=0 \
	-D CMAKE_EXE_LINKER_FLAGS="-L${mingwdir}/lib -u _WinMain@16 -static-libgcc -static-libstdc++ -mwindows" \
	"${olxdir}"
cmakerun=$?

[ "$cachemoved" = "0" ] && mv "${olxdir}/CMakeCache.txt.old" "${olxdir}/CMakeCache.txt"

[ "$cmakerun" != "0" ] && echo "cmake failed" && exit 1

make -j8 VERBOSE=1
