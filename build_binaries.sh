#!/bin/bash

set -e # exit when any command fails

if [ -d "./swift-package-collection-generator" ]; then
	cd swift-package-collection-generator
	git pull
else
	git clone https://github.com/apple/swift-package-collection-generator.git
	cd swift-package-collection-generator
fi
swift build -c release
[ -d "../bin" ] || mkdir ../bin
cp .build/release/package-collection-generate ../bin/
cp .build/release/package-collection-sign ../bin/
