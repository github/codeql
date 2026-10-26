#!/bin/sh

set -eu

export RUST_BACKTRACE=1
exec "$CODEQL_EXTRACTOR_RUST_ROOT/tools/$CODEQL_PLATFORM/autobuild"
