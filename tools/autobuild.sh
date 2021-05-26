#!/bin/sh

set -eu

exec "${CODEQL_DIST}/codeql" database index-files \
    --include-extension=.ql \
    --include-extension=.qll \
    --size-limit=5m \
    --language=ql \
    --working-dir=.\
    "$CODEQL_EXTRACTOR_QL_WIP_DATABASE"
