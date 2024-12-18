#!/bin/bash

set -eu

"$CODEQL_DIST/codeql" database index-files \
    --include-extension=.yaml \
    --include-extension=.yml \
    --size-limit=5m \
    --language yaml \
    -- \
    "$CODEQL_EXTRACTOR_PYTHON_WIP_DATABASE"
