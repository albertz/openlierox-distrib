#!/bin/sh
if [ -z "$1" ] ; then echo Usage: $0 DllFile.dll ; exit ; fi
wine pexports.exe $1 > DefFile.def
i586-mingw32msvc-dlltool --input-def DefFile.def --dllname $1 --output-lib lib$1.a
