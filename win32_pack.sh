#!/bin/zsh

cd "$(dirname "$0")"
distribdir="$(pwd)"

source functions.sh

olxdir="$(guess_olx_dir)"
cd $olxdir
olxdir="$(pwd)" # to have absolute filename

if ! is_olx_dir "$olxdir"; then
	echo "Cannot find openlierox dir. Fix functions.sh."
	exit 1
fi


VERSION="$(get_olx_version)"
echo ">>> preparing $VERSION archives ..."


win32_files=(doc COPYING.LIB ${olxdir}/share/gamedir/* ${distribdir}/build-win32/* ${distribdir}/win32/*)
win32patch_files=(${distribdir}/build-win32/* share/gamedir/cfg share/gamedir/data ${distribdir}/win32/*)


# $1 - zip filename
# $[1:] - array of files
function create_archiv() {
	files=($*)
	files=($files[2,-1])
	zipfile=$1

	rm -f $zipfile 2>/dev/null
	echo ">>> creating $(basename $zipfile) ..."

	cd ${distribdir} || {
		echo "create_archiv: cd to distrib failed"
		return 1
	}

	[ -d win32tmp ] && rm -rf win32tmp
	mkdir -p win32tmp/OpenLieroX || {
		echo "create_archiv: cannot create tmp directory"
		return 1
	}

	for f in $files; do
		[ "$f[1]" != "/" ] && f="${olxdir}/$f"
		[ ! -e $f ] && {
			echo "create_archiv $(basename $zipfile): cannot find $f"
			return 1
		}
		{ tar -c \
			--exclude=.svn --exclude=.git --exclude=.pyc --exclude=~ \
			-C "$(dirname $f)" "$(basename $f)" \
		| tar -x -C win32tmp/OpenLieroX; } || {
			echo "create_archiv $(basename $zipfile): Couldn't copy $f"
			return 1
		}
		echo -n "+"
	done
	echo -n " "

	cd win32tmp
	zip -r -9 $zipfile OpenLieroX | { while read t; do echo -n "."; done; } || {
		echo "create_archiv $(basename $zipfile): error while zipping"
		return 1
	}
	cd ..

	echo -n " -"
	rm -rf win32tmp
	echo " *"

}


#create_archiv "${distribdir}/$(get_olx_win32debug_fn)" $win32debug_files && \

#create_archiv "${distribdir}/$(get_olx_win32patch_fn)" $win32patch_files || exit 1
create_archiv "${distribdir}/$(get_olx_win32_fn)" $win32_files || exit 1
