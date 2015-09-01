#!/bin/bash
VERSION=0.10.9
TMP_DIR=~/tmp
BUILD_DIR=$TMP_DIR/build

# Download and prepare dirs
mkdir -p $TMP_DIR && cd $TMP_DIR 
rm -f Pritunl.pkg.zip && wget https://github.com/pritunl/pritunl-client-electron/releases/download/$VERSION/Pritunl.pkg.zip
rm -f Pritunl.pkg && unzip Pritunl.pkg.zip
mkdir -p $BUILD_DIR && cd $BUILD_DIR && rm -rf Pritunl.unpkg


# Unpack original package
pkgutil --expand ../Pritunl.pkg Pritunl.unpkg
mkdir -p $BUILD_DIR/Pritunl.pkg && cd $BUILD_DIR/Pritunl.pkg

# Unpack payload
cat $BUILD_DIR/Pritunl.unpkg/Build.pkg/Payload | gzip -d | cpio -id

echo You can now update $BUILD_DIR/Pritunl.pkg/Applications/Pritunl.app/Contents/Resources/app
