#!/bin/bash

source "$(dirname "$0")"/functions.sh

if [ "$1" != "" ]; then
	bin="$1"
	# if no absolute filename, add $(pwd)
	[ "$(echo "$bin" | head -c 1)" != "/" ] && bin="$(pwd)/$1"
	if ! is_olx_macosx_bin "$bin"; then
		echo "Given parameter $bin is not a MacOSX binary."
		exit 1
	fi
else
	bin="$(get_olx_macosx_bin)"
	
	if ! is_olx_macosx_bin "$bin"; then
		echo "Guessed filename $bin is not a MacOSX binary."
		exit 1
	fi	
fi

olxdir="$(guess_olx_dir)"

cd "$bin/.."

if [ ! -d "OpenLieroX.app" ]; then
	echo "OpenLieroX.app not found in $bin/.."
	exit 1
fi

		echo ">>> copying gamedir"
		rsync -a --delete --exclude=.pyc --exclude=gmon.out --exclude=.svn "$olxdir"/share/gamedir OpenLieroX.app/Contents/Resources/

		for framework in \
			GD.framework/Versions/2.0/GD \
			UnixImageIO.framework/Versions/A/UnixImageIO \
			UnixImageIO.framework/Versions/B/UnixImageIO \
			FreeType.framework/Versions/2.3/FreeType;
		do
			echo ">>> fixing $framework"
			install_name_tool -change /Library/Frameworks/$framework @executable_path/../Frameworks/$framework \
				OpenLieroX.app/Contents/MacOS/OpenLieroX

			fr_path=$(echo $framework | cut -d / -f 1,2,3 -) 
			files="OpenLieroX.app/Contents/Frameworks/$framework"
			[ -e OpenLieroX.app/Contents/Frameworks/$fr_path/Libraries ] && \
				files=$(echo $files OpenLieroX.app/Contents/Frameworks/$fr_path/Libraries/*)
			files=${files//"OpenLieroX.app\/Contents\/Frameworks"//Library/Frameworks}
			files=$(echo $files; \
				otool -L OpenLieroX.app/Contents/Frameworks/$framework | \
				grep "/Library/Frameworks/" | grep -v "/System/Library" | \
				cut -d " " -f 1)
			for lib in $files
			do
				echo "> fixing link $lib"
				for file in $files; do
					install_name_tool -change $lib ${lib/\/Library\/Frameworks/@executable_path/../Frameworks} \
						${file/\/Library\/Frameworks/OpenLieroX.app/Contents/Frameworks}
				done
			done
		done

# simple crash reporter
if [ -x "${olxdir}/src/breakpad/external/src/tools/mac/crash_report/build/Release/crash_report" ]; then
	echo ">>> placing simple crash reporter"
	cp "${olxdir}/src/breakpad/external/src/tools/mac/crash_report/build/Release/crash_report" OpenLieroX.app/Contents/Resources/ || exit 1
	cp "${olxdir}/tools/CrashReporter/SimpleCrashReporter.py" OpenLieroX.app/Contents/Resources/CrashReporter || exit 1
fi
