#!/bin/bash

SCRIPTPATH="$(dirname "$0")"
CURRENT="$(pwd)"

cd $SCRIPTPATH
swift build -c release
cp -f .build/release/image-resizer /usr/local/bin/image-resizer
rm -r .build/release

echo "Installed image-resizer into /usr/local/bin/"

cd $CURRENT
