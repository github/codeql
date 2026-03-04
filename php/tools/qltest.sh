#!/bin/sh

set -eu

exec "${CODEQL_DIST}/codeql" database index-files \
    --prune="**/*.testproj" \
    --include-extension=.php \
    --include-extension=.phtml \
    --include-extension=.inc \
    --size-limit=5m \
    --language=php \
    --working-dir=.\
    "$CODEQL_EXTRACTOR_PHP_WIP_DATABASE"
