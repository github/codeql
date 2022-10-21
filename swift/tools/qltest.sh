#!/bin/bash

mkdir -p "$CODEQL_EXTRACTOR_SWIFT_TRAP_DIR"

QLTEST_LOG="$CODEQL_EXTRACTOR_SWIFT_LOG_DIR"/qltest.log

export LD_LIBRARY_PATH="$CODEQL_EXTRACTOR_SWIFT_ROOT/tools/$CODEQL_PLATFORM"

EXTRACTOR="$CODEQL_EXTRACTOR_SWIFT_ROOT/tools/$CODEQL_PLATFORM/extractor"
SDK="$CODEQL_EXTRACTOR_SWIFT_ROOT/qltest/$CODEQL_PLATFORM/sdk"

for src in *.swift; do
  opts=(-sdk "$SDK" -c -primary-file "$src")
  opts+=($(sed -n '1 s=//codeql-extractor-options:==p' $src))
  echo -e "calling extractor with flags: ${opts[@]}\n" >> $QLTEST_LOG
  if ! "$EXTRACTOR" "${opts[@]}" >> $QLTEST_LOG 2>&1; then
    FAILED=1
  fi
done

if [ -n "$FAILED" ]; then
  cat "$QLTEST_LOG" # Show compiler errors on extraction failure
  exit 1
fi
