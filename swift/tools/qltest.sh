#!/bin/bash

mkdir -p "$CODEQL_EXTRACTOR_SWIFT_TRAP_DIR"

QLTEST_LOG="$CODEQL_EXTRACTOR_SWIFT_LOG_DIR"/qltest.log

EXTRACTOR="$CODEQL_EXTRACTOR_SWIFT_ROOT/tools/$CODEQL_PLATFORM/extractor"
SDK="$CODEQL_EXTRACTOR_SWIFT_ROOT/qltest/$CODEQL_PLATFORM/sdk"

for src in *.swift; do
  env=()
  opts=(-sdk "$SDK" -c -primary-file "$src")
  opts+=($(sed -n '1 s=//codeql-extractor-options:==p' $src))
  expected_status=$(sed -n 's=//codeql-extractor-expected-status:[[:space:]]*==p' $src)
  expected_status=${expected_status:-0}
  env+=($(sed -n '1 s=//codeql-extractor-env:==p' $src))
  echo -e "calling extractor with flags: ${opts[@]}\n" >> $QLTEST_LOG
  env "${env[@]}" "$EXTRACTOR" "${opts[@]}" >> $QLTEST_LOG 2>&1
  actual_status=$?
  if [[ $actual_status != $expected_status ]]; then
    FAILED=1
  fi
done

if [ -n "$FAILED" ]; then
  cat "$QLTEST_LOG" # Show compiler errors on extraction failure
  exit 1
fi
