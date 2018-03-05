#!/bin/bash

[ "$(whoami)" != "root" ] && {
	sudo $0
	exit $?
}

[ ! -x /usr/sbin/pbuilder ] && {
	apt-get install pbuilder || {
		echo "Cannot install pbuilder."
		exit 1
	}
}

dist=jessie

pbuilder create --distribution $dist --override-config --othermirror "deb http://http.us.debian.org/debian $dist main"  --mirror "http://ftp.de.debian.org/debian/" #--architecture i386
