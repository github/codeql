#!/bin/sh

set -eu

exec "$CODEQL_EXTRACTOR_RUST_ROOT/tools/$CODEQL_PLATFORM/extractor" --inputs-file="$1"
