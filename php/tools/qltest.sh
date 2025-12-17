#!/bin/sh

set -eu

# This script indexes PHP source files into the CodeQL database for testing
# It uses the CodeQL CLI directly instead of the custom extractor

# Verify that CODEQL_DIST is set (location of CodeQL CLI)
CODEQL_DIST="${CODEQL_DIST:?CODEQL_DIST not set}"

# The work-in-progress database directory
WIP_DATABASE="${CODEQL_EXTRACTOR_PHP_WIP_DATABASE:?CODEQL_EXTRACTOR_PHP_WIP_DATABASE not set}"

# Use the CodeQL CLI to index PHP files
# This approach is used for testing and provides more control over indexing
exec "${CODEQL_DIST}/codeql" database index-files \
    --prune="**/*.test" \
    --include-extension=.php \
    --include-extension=.php5 \
    --include-extension=.php7 \
    --size-limit=10m \
    --language=php \
    --working-dir=. \
    "$WIP_DATABASE"
