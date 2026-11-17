#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.."

cargo llvm-cov --version > /dev/null

test_status=0
cargo llvm-cov --package swift-parser --test fixtures --no-report -- --fixtures-only \
    || test_status=$?

report_status=0
cargo llvm-cov report --package swift-parser \
    --ignore-filename-regex '/(test-runner|extractor)/' \
    --fail-uncovered-lines 0 \
    --fail-uncovered-regions 0 \
    --fail-uncovered-functions 0 \
    --show-missing-lines \
    "$@" || report_status=$?

if [ "$test_status" -ne 0 ]; then
    exit "$test_status"
fi
exit "$report_status"
