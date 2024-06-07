#!/bin/bash

set -eu

"$CODEQL_DIST/codeql" database index-files \
    "--include=**/qlpack.yml" \
    --size-limit=5m \
    --language yaml \
    -- \
    "$CODEQL_EXTRACTOR_QL_WIP_DATABASE"
