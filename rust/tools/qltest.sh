#!/bin/bash

set -eu

export RUST_BACKTRACE=full
QLTEST_LOG="$CODEQL_EXTRACTOR_RUST_LOG_DIR"/qltest.log
if ! "$CODEQL_EXTRACTOR_RUST_ROOT/tools/$CODEQL_PLATFORM/extractor" --qltest &>> "$QLTEST_LOG"; then
  cat "$QLTEST_LOG"
  exit 1
fi
