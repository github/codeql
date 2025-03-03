#!/bin/bash

set -eu

export RUST_BACKTRACE=full
QLTEST_LOG="$CODEQL_EXTRACTOR_RUST_LOG_DIR"/qltest.log

if [ -f "Cargo.lock" ]; then
  SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
  if ! /usr/bin/env python "${SCRIPT_DIR}/autobuild.py" >> "$QLTEST_LOG" 2>&1; then
    cat "$QLTEST_LOG"
    exit 1
  fi
else
  if ! "$CODEQL_EXTRACTOR_RUST_ROOT/tools/$CODEQL_PLATFORM/extractor" --qltest >> "$QLTEST_LOG" 2>&1; then
    cat "$QLTEST_LOG"
    exit 1
  fi
fi