#!/bin/sh

set -eu

# This script is invoked by CodeQL to extract PHP source files during database creation
# It reads a file list and calls the PHP extractor to generate TRAP facts

# Get the root of the PHP extractor pack (set by CodeQL)
EXTRACTOR_ROOT="${CODEQL_EXTRACTOR_PHP_ROOT:-$(dirname "$(readlink -f "$0")/..")}"
EXTRACTOR_PLATFORM="${CODEQL_PLATFORM:-linux64}"

# The TRAP directory where extracted facts are written
TRAP_DIR="${CODEQL_EXTRACTOR_PHP_TRAP_DIR:?CODEQL_EXTRACTOR_PHP_TRAP_DIR not set}"

# Create TRAP directory if it doesn't exist
mkdir -p "$TRAP_DIR"

# Call the PHP extractor with the extract subcommand
# $1 is the file list (path to a file containing paths of files to extract)
exec "${EXTRACTOR_ROOT}/tools/${EXTRACTOR_PLATFORM}/codeql-extractor-php" extract \
    --file-list "$1" \
    --output-dir "$TRAP_DIR"
