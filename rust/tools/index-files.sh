#!/bin/sh

set -eu

exec "$CODEQL_EXTRACTOR_RUST_ROOT/tools/$CODEQL_PLATFORM/extractor" @"$1"
