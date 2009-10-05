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
echo ">>> preparing $VERSION src archive ..."


src_files=(build CMakeLists.txt ${olxdir}/*.sh start.bat COPYING.LIB DEPS VERSION doc include src libs share)

# not all releases have that file
for f in PCHSupport_26.cmake optional-includes; do
	test -e ${olxdir}/$f && src_files+="$f"
done

# $1 - zip filename
# $[1:] - array of files
function create_archiv() {
	files=($*)
	files=($files[2,-1])
	tarfile=$1

	rm -f $tarfile 2>/dev/null
	echo ">>> creating $(basename $tarfile) ..."

	cd ${distribdir} || {
		echo "create_archiv: cd to distrib failed"
		return 1
	}

	[ -d tmparchiv ] && rm -rf tmparchiv
	mkdir -p tmparchiv/OpenLieroX || {
		echo "create_archiv: cannot create tmp directory"
		return 1
	}

	for f in $files; do
		[ "$f[1]" != "/" ] && f="${olxdir}/$f"
		[ ! -e $f ] && {
			echo "create_archiv $(basename $tarfile): cannot find $f"
			return 1
		}
		{ tar -c \
			--exclude-vcs --exclude=.svn --exclude=.git \
			--exclude=.pyc --exclude=~ \
			$( [ -e ${olxdir}/.gitignore ] && echo "--exclude-from=${olxdir}/.gitignore" ) \
			-C "$(dirname $f)" "$(basename $f)" \
		| tar -x -C tmparchiv/OpenLieroX; } || {
			echo "create_archiv $(basename $tarfile): Couldn't copy $f"
			return 1
		}
		echo -n "+"
	done
	echo -n " "

	cd tmparchiv
	tar -cjf $tarfile OpenLieroX || {
		echo "create_archiv $(basename $tarfile): error while zipping"
		return 1
	}
	cd ..

	echo -n " -"
	rm -rf tmparchiv
	echo " *"

}


create_archiv "${distribdir}/$(get_olx_src_fn)" $src_files

if is_gentoo; then
	${distribdir}/src_test_ebuild.sh || {
		echo "Ebuild build test failed."
		exit 1
	}
fi

# Note: it could be that this release doesnt has a compile.sh anymore
if [ -x ${olxdir}/compile.sh ]; then
	${distribdir}/src_test_compile.sh || {
		echo "Compile test failed."
		exit 1
	}
fi

${distribdir}/src_test_cmake.sh || {
	echo "Compile test (based on Cmake) failed."
	exit 1
}

