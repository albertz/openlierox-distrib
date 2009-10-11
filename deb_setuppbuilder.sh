#!/bin/bash

[ "$(whoami)" != "root" ] && {
	sudo $0
	exit $?
}

apt-get install pbuilder

dist=etch

pbuilder create --distribution $dist --override-config --othermirror "deb http://http.us.debian.org/debian $dist main"  --mirror "http://http.us.debian.org/debian"
