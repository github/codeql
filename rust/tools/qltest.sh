#!/bin/bash

mkdir -p "$CODEQL_EXTRACTOR_RUST_TRAP_DIR"

export RUST_BACKTRACE=full

QLTEST_LOG="$CODEQL_EXTRACTOR_RUST_LOG_DIR"/qltest.log

EXTRACTOR="$CODEQL_EXTRACTOR_RUST_ROOT/tools/$CODEQL_PLATFORM/extractor"
echo > lib.rs
for src in *.rs; do
  echo "mod ${src%.rs};" >> lib.rs
done
cat > Cargo.toml << EOF
[workspace]
[package]
name = "test"
version="0.0.1"
edition="2021"
[lib]
path="lib.rs"
EOF
"$EXTRACTOR" *.rs >> "$QLTEST_LOG"
if [[ "$?" != 0 ]]; then
  cat "$QLTEST_LOG" # Show compiler errors on extraction failure
  exit 1
fi
