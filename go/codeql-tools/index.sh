#!/bin/sh

set -eu

if [ "$CODEQL_PLATFORM" != "linux64" ] && [ "$CODEQL_PLATFORM" != "osx64" ] ; then
    echo "Automatic build detection for $CODEQL_PLATFORM is not implemented."
    exit 1
fi

"$CODEQL_EXTRACTOR_GO_ROOT/tools/$CODEQL_PLATFORM/go-extractor" -mod=vendor ./...
"$CODEQL_EXTRACTOR_GO_ROOT/tools/pre-finalize.sh"
