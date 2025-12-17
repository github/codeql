#!/bin/sh

set -eu

exec "${CODEQL_DIST}/codeql" database index-files \
    --prune="**/*.testproj" \
    --include-extension=.php \
    --exclude="**/.git" \
    --size-limit=5m \
    --language=php \
    --working-dir=.\
    "$CODEQL_EXTRACTOR_PHP_WIP_DATABASE"
