#!/bin/sh

set -eu

"${CODEQL_DIST}/codeql" database index-files \
    --prune="**/*.testproj" \
    --include-extension=.swift \
    --include-extension=.swiftinterface \
    --size-limit=5m \
    --language=unified \
    --working-dir=.\
    "$CODEQL_EXTRACTOR_UNIFIED_WIP_DATABASE"
