#!/bin/sh

set -eu

if [ "$CODEQL_PLATFORM" != "linux64" ] && [ "$CODEQL_PLATFORM" != "osx64" ] ; then
    echo "Automatic build detection for $CODEQL_PLATFORM is not implemented."
    exit 1
fi

# Some legacy environment variables used by the autobuilder.
LGTM_SRC="$(pwd)"
export LGTM_SRC

if [ "${CODEQL_EXTRACTOR_GO_BUILD_TRACING:-}" = "on" ]; then
  echo "Tracing enabled"
  "$CODEQL_EXTRACTOR_GO_ROOT/tools/$CODEQL_PLATFORM/go-build-runner"
else
  "$CODEQL_EXTRACTOR_GO_ROOT/tools/$CODEQL_PLATFORM/go-autobuilder"
fi
