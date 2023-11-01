#!/bin/sh

set -eu

"${CODEQL_DIST}/codeql" database index-files \
    --prune="**/*.testproj" \
    --include-extension=.ql \
    --include-extension=.qll \
    --include-extension=.dbscheme \
    --size-limit=5m \
    --language=ql \
    --working-dir=.\
    "$CODEQL_EXTRACTOR_QL_WIP_DATABASE"

exec "${CODEQL_DIST}/codeql" database index-files \
    --prune="**/*.testproj" \
    --include-extension=.yml \
    --size-limit=5m \
    --language=yaml \
    --working-dir=.\
    "$CODEQL_EXTRACTOR_QL_WIP_DATABASE"
