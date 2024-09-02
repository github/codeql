#!/bin/bash

mkdir -p "$CODEQL_EXTRACTOR_RUST_TRAP_DIR"

export RUST_BACKTRACE=full

QLTEST_LOG="$CODEQL_EXTRACTOR_RUST_LOG_DIR"/qltest.log

EXTRACTOR="$CODEQL_EXTRACTOR_RUST_ROOT/tools/$CODEQL_PLATFORM/extractor"
for src in *.rs; do
  echo -e "[package]\nname = \"test\"\nversion=\"0.0.1\"\n[lib]\npath=\"$src\"\n" > Cargo.toml
  env=()
  opts=("$src")
  opts+=($(sed -n '1 s=//codeql-extractor-options:==p' $src))
  expected_status=$(sed -n 's=//codeql-extractor-expected-status:[[:space:]]*==p' $src)
  expected_status=${expected_status:-0}
  env+=($(sed -n '1 s=//codeql-extractor-env:==p' $src))
  echo >> $QLTEST_LOG
  echo "env ${env[@]} $EXTRACTOR ${opts[@]}" >> "$QLTEST_LOG"
  env "${env[@]}" "$EXTRACTOR" "${opts[@]}" >> $QLTEST_LOG 2>&1
  actual_status=$?
  if [[ $actual_status != $expected_status ]]; then
    FAILED=1
  fi
done

rm -rf Cargo.*

if [ -n "$FAILED" ]; then
  cat "$QLTEST_LOG" # Show compiler errors on extraction failure
  exit 1
fi
