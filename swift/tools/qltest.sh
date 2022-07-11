#!/bin/bash

mkdir -p "$CODEQL_EXTRACTOR_SWIFT_TRAP_DIR"

QLTEST_LOG="$CODEQL_EXTRACTOR_SWIFT_LOG_DIR"/qltest.log

export LD_LIBRARY_PATH="$CODEQL_EXTRACTOR_SWIFT_ROOT/tools/$CODEQL_PLATFORM"

for src in *.swift; do
  opts=(-sdk "$CODEQL_EXTRACTOR_SWIFT_ROOT/qltest/$CODEQL_PLATFORM/sdk" -c -primary-file $src)
  opts+=($(sed -n '1 s=//codeql-extractor-options:==p' $src))
  echo -e "calling extractor with flags: ${opts[@]}\n" >> $QLTEST_LOG
  "$CODEQL_EXTRACTOR_SWIFT_ROOT/tools/$CODEQL_PLATFORM/extractor" "${opts[@]}" >> $QLTEST_LOG 2>&1
done
