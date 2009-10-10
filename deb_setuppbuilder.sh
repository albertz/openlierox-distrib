#!/bin/bash

[ "$(whoami)" != "root" ] && {
	sudo $0
	exit $?
}

apt-get install pbuilder
pbuilder create --distribution etch --override-config --othermirror "deb http://http.us.debian.org/debian etch main"  --mirror "http://http.us.debian.org/debian"
