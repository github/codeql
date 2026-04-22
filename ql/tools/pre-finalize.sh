#!/bin/bash

set -eu

"$CODEQL_DIST/codeql" database index-files \
    "--include=**/qlpack.yml" \
    --include-extension=.qlref \
    --also-match-lgtm-index-filters \
    --size-limit=5m \
    --language yaml \
    -- \
    "$CODEQL_EXTRACTOR_QL_WIP_DATABASE"
