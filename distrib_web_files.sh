#!/bin/bash

[ "$USERNAME" == "" ] && [ $(whoami) == az ] && USERNAME=albertzeyer
SERVER="$USERNAME,openlierox@web.sourceforge.net"
REMOTEDIR="/home/groups/o/op/openlierox/htdocs/"
DEST="$SERVER:$REMOTEDIR"
SYNC_CMD="rsync -avP --exclude .svn"

if [ "$1" == "dest" ]; then
	echo "$DEST"
	exit 0
elif [ "$1" == "cmd" ]; then
	echo "$SYNC_CMD"
	exit 0
elif [ "$1" == "sync" ]; then
	{} # just continue
else
	echo "usage: $0 sync|dest|cmd"
	exit 1
fi



[ -e tmpbuild/* ] 2>/dev/null && {
	f=$(echo tmpbuild/*)
	ssh $SERVER "cd $REMOTEDIR; [ -e tmpbuild/* ] 2>/dev/null && \
		[ tmpbuild/* != $f ] && \
		echo 'single tmpbuild-file, renaming' && \
		mv tmpbuild/* $f"
}

# first, upload all new files
#$SYNC_CMD additions $DEST
#$SYNC_CMD tmpbuild $DEST
$SYNC_CMD ebuild $DEST

# now, update the site itself
$SYNC_CMD web/* $DEST

# and lastly, clean up old files
$SYNC_CMD --delete web/* $DEST
$SYNC_CMD --delete ebuild $DEST
#$SYNC_CMD --delete-after tmpbuild $DEST
