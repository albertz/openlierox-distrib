#!/bin/bash

cd "$(dirname "$0")"
distribdir="$(pwd)"

source functions.sh

olxdir="$(guess_olx_dir)"

if ! is_olx_dir "$olxdir"; then
	echo "Cannot find openlierox dir. Fix functions.sh."
	exit 1
fi


#vcbuild="/cygdrive/c/Program Files/Microsoft Visual Studio 8/VC/vcpackages/vcbuild.exe"

#cd "${olxdir}/build/msvc 2005"

vcbuildpath="/cygdrive/c/Program Files/Microsoft Visual Studio 8/VC/vcpackages"
#vcbuild="$vcbuildpath/vcbuild.exe"

#cp "$vcbuildpath/1031/"* "$vcbuildpath/"

# seems this is needed, otherwise error
#regsvr32 /s "$vcbuildpath/vcprojectengine.dll"

# we need this translation to absolute pathname so that Win CMD can handle it correctly
cd "$olxdir"
olxdir="$(pwd)"

# start the build itself
cd "$vcbuildpath"
"${distribdir}/win32_runbuild.bat" "$(cygpath -a -w "$olxdir")/build/msvc 2005/Game.vcproj"

# if the task is still running, kill it
sleep 1
taskkill /F /IM cl.exe 2>/dev/null

echo "** ready"


