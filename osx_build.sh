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
CFLAGS="-gdwarf-2 -O3 -mmacosx-version-min=10.6 -isysroot /Developer/SDKs/MacOSX10.6.sdk -arch x86_64" # -arch i386 more complicated...

cmake \
	-DCMAKE_C_FLAGS="$CFLAGS" -DCMAKE_CXX_FLAGS="$CFLAGS" \
	-DCMAKE_C_FLAGS_RELEASE="" -DCMAKE_CXX_FLAGS_RELEASE="" \
	-DDEBUG=Off .
make -j4

mkdir -p OpenLieroX.app/Contents/MacOS
echo -n "APPL????" >OpenLieroX.app/Contents/PkgInfo

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

cp bin/openlierox OpenLieroX.app/Contents/MacOS/
cp -a $olxdir/share OpenLieroX.app/Contents/Resources
