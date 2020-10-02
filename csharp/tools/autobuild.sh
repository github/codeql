#!/bin/sh

set -eu

if [ "$CODEQL_PLATFORM" != "linux64" ] && [ "$CODEQL_PLATFORM" != "osx64" ] ; then
    echo "Automatic build detection for $CODEQL_PLATFORM is not implemented."
    exit 1
fi

"$CODEQL_EXTRACTOR_CSHARP_ROOT/tools/$CODEQL_PLATFORM/Semmle.Autobuild.CSharp" || exit $?
