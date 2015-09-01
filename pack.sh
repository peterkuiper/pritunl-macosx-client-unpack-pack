#!/bin/bash
VERSION=0.10.9
TMP_DIR=~/tmp
BUILD_DIR=$TMP_DIR/build

rm -f $BUILD_DIR/Pritunl.unpkg/Build.pkg/{Payload,Bom}

# Create new Payload and new Bom
cd $BUILD_DIR/Pritunl.pkg
find . | cpio -o --format odc | gzip -c \
  > $BUILD_DIR/Pritunl.unpkg/Build.pkg/Payload
mkbom $BUILD_DIR/Pritunl.pkg $BUILD_DIR/Pritunl.unpkg/Build.pkg/Bom

# Get installBytes and numberOfFiles
INSTALL_BYTES=$(expr $(du -sk ~/tmp/build/Pritunl.pkg/ | awk -F ' ' ' { print $1 } ') - 4)
NUMBER_OF_FILES=`find ~/tmp/build/Pritunl.pkg/ | wc | awk -F ' ' ' { print $1 } '`

sed -E "s/(numberOfFiles=)\".*\" (installKBytes=)\".*\"/\1\"$NUMBER_OF_FILES\" \2\"$INSTALL_BYTES\"/" \
    $BUILD_DIR/Pritunl.unpkg/Build.pkg/PackageInfo > $BUILD_DIR/Pritunl.unpkg/Build.pkg/PackageInfo.tmp

# Recreate package
pkgutil --flatten $BUILD_DIR/Pritunl.unpkg/ $TMP_DIR/Pritunl.new.pkg

echo Your new package is now at $TMP_DIR/Pritunl.new.pkg
