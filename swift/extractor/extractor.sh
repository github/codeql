#!/bin/bash

EXE_DIR="$(dirname "$0")"

if [[ "$(uname)" == Darwin ]]; then
  export DYLD_LIBRARY_PATH="$EXE_DIR"
else
  export LD_LIBRARY_PATH="$EXE_DIR"
fi

TOOL="$CODEQL_EXTRACTOR_SWIFT_RUN_UNDER"

if [[ -n "$CODEQL_EXTRACTOR_SWIFT_RUN_UNDER_FILTER" ]]; then
  if [[ ! "$*" =~ $CODEQL_EXTRACTOR_SWIFT_RUN_UNDER_FILTER ]]; then
    TOOL=
  fi
fi

exec -a swift-frontend $TOOL "$EXE_DIR/swift-frontend" "$@"
