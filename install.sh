#!/bin/bash

SCRIPTPATH="$(dirname "$0")"
CURRENT="$(pwd)"

cd $SCRIPTPATH
swift build -c release
cp -f .build/release/hpresizer /usr/local/bin/hpresizer
rm -r .build/release

echo "Installed hpresizer into /usr/local/bin/"

cd $CURRENT
