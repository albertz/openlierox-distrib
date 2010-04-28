#!/bin/bash

cd "$(dirname "$0")"
distribdir="$(pwd)"

source functions.sh

ftplogin="$(cat web_update_login)"
if [ "$ftplogin" == "" ]; then
	echo "web_update_login must contain the full ftp login (user:pass@server)"
	exit 1
fi

VERSION="$(get_olx_version)"
DATE="$(date "+%Y-%m-%d")"
file="download_beta_links.dat"

echo "<?php" > "${file}"
echo "\$newestBetaVersion_cpu = \"OpenLieroX/${VERSION}\";" >> "${file}"
echo "\$newestBetaReleaseDate = \"${DATE}\";" >> "${file}"
echo "?>" >> "${file}"

ftp -u "ftp://${ftplogin}/" $file
rm $file
