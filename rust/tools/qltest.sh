#!/bin/bash

set -eu
set -o pipefail

export RUST_BACKTRACE=full
QLTEST_LOG="$CODEQL_EXTRACTOR_RUST_LOG_DIR"/qltest.log
mkdir -p "$CODEQL_EXTRACTOR_RUST_SCRATCH_DIR"
TMP_OUT="$(mktemp --tmpdir="$CODEQL_EXTRACTOR_RUST_SCRATCH_DIR" qltest-XXXXXX.log))"
trap 'rm -f "$TMP_OUT"' EXIT
# put full-color output on the side, but remove the color codes from the log file
# also, print (colored) output only in case of failure
if ! "$CODEQL_EXTRACTOR_RUST_ROOT/tools/$CODEQL_PLATFORM/extractor" \
     --qltest \
     --logging-verbosity=progress+ \
     2>&1 \
     | tee "$TMP_OUT" \
     | sed 's/\x1B\[[0-9;]\{1,\}[A-Za-z]//g' \
     > "$QLTEST_LOG"; then
  cat "$TMP_OUT"
  exit 1
fi
