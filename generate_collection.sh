#!/bin/bash

set -e # exit when any command fails

if [ ! $# -eq 5 ]; then
	echo "Correct usage: $0 <package_list.json> <revision> <private_key.pem> <certificate.cer> <output.json>"
	exit 1
fi

PACKAGE_LIST="$1"
REVISION_NUMBER="$2"
PRIVATE_KEY="$3"
CERTIFICATE="$4"
OUTPUT="$5"

if [ ! -f "$PACKAGE_LIST" ]; then
	echo "Package list file not found at \"$PACKAGE_LIST\""
	exit 1
fi

if [ ! -f "$PRIVATE_KEY" ]; then
	echo "Private key file not found at \"$PRIVATE_KEY\""
	exit 1
fi

if [ ! -f "$CERTIFICATE" ]; then
	echo "Certificate file not found at \"$CERTIFICATE\""
	exit 1
fi

UNSIGNED_COLLECTION_PATH="unsigned-collection.json"

bin/package-collection-generate "$PACKAGE_LIST" "$UNSIGNED_COLLECTION_PATH" --revision "$REVISION_NUMBER"
# --auth-token "github:github.com:$GITHUB_TOKEN"

bin/package-collection-sign "$UNSIGNED_COLLECTION_PATH" "$OUTPUT" "$PRIVATE_KEY" "$CERTIFICATE" "ca-intermediate.cer" "ca-root.cer"
