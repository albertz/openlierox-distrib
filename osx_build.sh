#!/bin/bash

distribdir="$(dirname "$0")"
cd "${distribdir}"

source functions.sh

olxdir="$(guess_olx_dir)"

if ! is_olx_dir "$olxdir"; then
	echo "Cannot find openlierox dir. Fix functions.sh."
	exit 1
fi

mkdir build-osx && {
	cd build-osx

	# we have to move the CMakeCache.txt away, otherwise cmake will not create a new config
	mv "${olxdir}/CMakeCache.txt" "${olxdir}/CMakeCache.txt.tmp"
	cmake "${olxdir}"
	mv "${olxdir}/CMakeCache.txt.tmp" "${olxdir}/CMakeCache.txt"
}

version=$(get_olx_human_version)

cd build-osx
CFLAGS="-gdwarf-2 -O3 -mmacosx-version-min=10.11 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk -arch x86_64" # -arch i386 more complicated...

cmake \
	-DCMAKE_C_FLAGS="$CFLAGS" -DCMAKE_CXX_FLAGS="$CFLAGS" \
	-DCMAKE_C_FLAGS_RELEASE="" -DCMAKE_CXX_FLAGS_RELEASE="" \
	-DCMAKE_EXE_LINKER_FLAGS="-F/Library/Frameworks -rpath @executable_path/../Frameworks" \
	-DDEBUG=Off .
make -j4 || exit 1

rm -r OpenLieroX.app
mkdir -p OpenLieroX.app/Contents/MacOS || exit 1
mkdir -p OpenLieroX.app/Contents/Frameworks || exit 1
echo -n "APPL????" >OpenLieroX.app/Contents/PkgInfo || exit 1

cat >OpenLieroX.app/Contents/Info.plist <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
<key>CFBundleDevelopmentRegion</key>
<string>English</string>
<key>CFBundleExecutable</key>
<string>OpenLieroX</string>
<key>CFBundleIconFile</key>
<string>macosx.icns</string>
<key>CFBundleIdentifier</key>
<string>com.OpenLieroX</string>
<key>CFBundleInfoDictionaryVersion</key>
<string>6.0</string>
<key>CFBundlePackageType</key>
<string>APPL</string>
<key>CFBundleSignature</key>
<string>????</string>
<key>CFBundleVersion</key>
<string>$version</string>
<key>NSMainNibFile</key>
<string>SDLMain</string>
<key>NSPrincipalClass</key>
<string>NSApplication</string>
</dict>
</plist>
EOF

cp bin/openlierox OpenLieroX.app/Contents/MacOS/ || exit 1
cp -a $olxdir/share OpenLieroX.app/Contents/Resources || exit 1
for F in SDL SDL_image SDL_mixer Ogg Vorbis FreeType; do
	cp -a /Library/Frameworks/$F.framework OpenLieroX.app/Contents/Frameworks/ || exit 1
done

{
cd OpenLieroX.app/Contents/MacOS

function liblocalcopy() {
bin="$1"
otool -L "$bin" | grep -E "\t+" | sed -E "s/^[[:space:]]+([^ ]+).*/\1/g" | { while read lib; do {
	echo $lib | grep $bin >/dev/null && continue
	locallib="$(basename $lib)"
	echo $lib | grep -E "^/usr/local/" >/dev/null && {
	libnewname="@executable_path/$locallib"
	install_name_tool -change "$lib" "$libnewname" "$bin"
	cp "$lib" .
	chmod u+w $locallib
	liblocalcopy $locallib
	}
}; done; }
}

liblocalcopy openlierox
}

exit 0


