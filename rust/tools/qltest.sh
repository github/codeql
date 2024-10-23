#!/bin/bash

mkdir -p "$CODEQL_EXTRACTOR_RUST_TRAP_DIR"

export RUST_BACKTRACE=full

QLTEST_LOG="$CODEQL_EXTRACTOR_RUST_LOG_DIR"/qltest.log
EXTRACTOR="$CODEQL_EXTRACTOR_RUST_ROOT/tools/$CODEQL_PLATFORM/extractor"
sysroot="$(rustc --print sysroot)"
sysroot_src="$sysroot/lib/rustlib/src/rust/library"
if [ ! -d "$sysroot_src" ]; then
  echo "rustlib source must be available" >&2
  if [[ "$CODEQL_THREADS" != 1 ]]; then
    echo "refusing to run rustup in parallel mode, please run" >&2
    echo "  rustup component add rust-src" >&2
    echo "and try again" >&2
    exit 1
  fi
  echo "running rustup to fetch it" >&2
  rustup component add rust-src
fi

echo > lib.rs
for src in *.rs; do
  if [[ "$src" == "lib.rs" ]]; then
    continue
  elif [[ "$src" == "main.rs" ]]; then
    continue
  else
    echo "mod ${src%.rs};" >> lib.rs
  fi
done
if [[ "$CODEQL_EXTRACTOR_RUST_TEST_GENERATE_CARGO" = true ]]; then
  rm -f .rust-project.json
  cat > Cargo.toml << EOF
[workspace]
[package]
name = "test"
version="0.0.1"
edition="2021"
[lib]
path="lib.rs"
EOF
  if [[ -f "main.rs" ]]; then
    cat >> Cargo.toml << EOF
[[bin]]
name = "main"
path = "main.rs"
EOF
  fi
else
  rm -f Cargo.{toml,lock}
  cat > .rust-project.json << EOF
{
  "sysroot": "$sysroot",
  "sysroot_src": "$sysroot_src",
  "crates": [
    {
      "root_module": "lib.rs",
      "edition": "2021",
      "deps": []
    }
EOF
  if [[ -f "main.rs" ]]; then
    cat >> .rust-project.json << EOF
    ,
    {
      "root_module": "main.rs",
      "edition": "2021",
      "deps": [{"crate": 0, "name": "lib"}]
    }
EOF
  fi
  echo -e "  ]\n}" >> .rust-project.json
fi

"$EXTRACTOR" *.rs &>> "$QLTEST_LOG"
if [[ "$?" != 0 ]]; then
  cat "$QLTEST_LOG" # Show compiler errors on extraction failure
  exit 1
fi
