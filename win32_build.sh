#!/bin/bash

distribdir="$(dirname "$0")"
cd "${distribdir}"

source functions.sh

olxdir="$(guess_olx_dir)"

if ! is_olx_dir "$olxdir"; then
	echo "Cannot find openlierox dir. Fix functions.sh."
	exit 1
fi


#vcbuild="/cygdrive/c/Program Files/Microsoft Visual Studio 8/VC/vcpackages/vcbuild.exe"

cd "${olxdir}/build/msvc 2005"

vcbuildpath="/cygdrive/c/Program Files/Microsoft Visual Studio 8/VC/vcpackages"

cd "$vcbuildpath"
#export PATH="$vcbuildpath:$PATH"
#export LD_LIBRARY_PATH="$vcbuildpath:$PATH"

#cmd /C "c: && pwd && cd C:/Program Files/Microsoft Visual Studio 8/VC/vcpackages && pwd"
#"/cygdrive/c/Program Files/Microsoft Visual Studio 8/VC/vcvarsall.bat" x86

#cmd /C "echo %PATH%"

./vcbuild "Game.vcproj" "Release|Win32" #/useenv


