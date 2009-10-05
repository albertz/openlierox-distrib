#!/bin/bash

distribdir="$(dirname "$0")"
cd "${distribdir}"

source functions.sh

olxdir="$(guess_olx_dir)"

if ! is_olx_dir "$olxdir"; then
	echo "Cannot find openlierox dir. Fix functions.sh."
	exit 1
fi

cd "${olxdir}"

dpkg-buildpackage -rfakeroot -sa \
	-I.svn -I.git -Idistrib -ICMakeFiles -Ibuild -I*stamp -IMakefile \
	-ICMakeCache.txt -Icmake* -Itools -Isandbox \
	-i\
"(?:^|/).*~$|"\
"(?:^|/)\.#.*$|"\
"(?:^|/)\..*\.swp$|"\
"(?:^|/),,.*(?:$|/.*$)|"\
"(?:^|/)(?:DEADJOE|\.cvsignore|\.arch-inventory|\.bzrignore)$|"\
"(?:^|/)(?:CVS|RCS|\.deps|\{arch\}|\.arch-ids|\.svn|_darcs|\.git|\.bzr(?:\.backup|tags)?)(?:$|/.*$)$|"\
"(?:^|/)(?:CMakeFiles|build|distrib|tools|Makefile|CMakeCache.txt|cmake)|"\
"(?:^|/)bin/.*$"
