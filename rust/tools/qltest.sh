#!/bin/bash

set -eu
set -o pipefail

export RUST_BACKTRACE=full
QLTEST_LOG="$CODEQL_EXTRACTOR_RUST_LOG_DIR/qltest.log"
QLTEST_COLORED_LOG="$CODEQL_EXTRACTOR_RUST_SCRATCH_DIR/qltest.log"
dirname "$QLTEST_LOG" "$QLTEST_COLORED_LOG" | xargs mkdir -p

if [ -f "Cargo.lock" ]; then
  SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
  if ! /usr/bin/env python3 "${SCRIPT_DIR}/autobuild.py" \
      2>&1 \
      | tee "$QLTEST_COLORED_LOG" \
      | sed 's/\x1B\[[0-9;]\{1,\}[A-Za-z]//g' \
      > "$QLTEST_LOG"; then
    cat "$QLTEST_COLORED_LOG"
    exit 1
  fi
else
  # put full-color output on the side, but remove the color codes from the log file
  # also, print (colored) output only in case of failure
  if ! "$CODEQL_EXTRACTOR_RUST_ROOT/tools/$CODEQL_PLATFORM/extractor" \
      --qltest \
      --logging-verbosity=progress+ \
      2>&1 \
      | tee "$QLTEST_COLORED_LOG" \
      | sed 's/\x1B\[[0-9;]\{1,\}[A-Za-z]//g' \
      > "$QLTEST_LOG"; then
    cat "$QLTEST_COLORED_LOG"
    exit 1
  fi
fi
