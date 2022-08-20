#!/bin/sh

set -eu

exec "${CODEQL_DIST}/codeql" database index-files \
    --prune="**/*.testproj" \
    --include-extension=.ql \
    --include-extension=.qll \
    --include-extension=.dbscheme \
    --include-extension=.yml \
    --size-limit=5m \
    --language=ql \
    --working-dir=.\
    "$CODEQL_EXTRACTOR_QL_WIP_DATABASE"
