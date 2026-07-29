#!/bin/bash
# Build `swift-syntax-parse`, the binary the Swift front-end shells out to, and
# print the path to it.
#
# By default this builds with Bazel, whose Swift toolchain is hermetic: nothing
# has to be installed locally. Pass `--cargo` to build through cargo instead,
# which is quicker to iterate on but needs a local Swift toolchain matching
# `swift-syntax-rs/.swift-version`. Both pin the same swift-syntax release, so
# the two produce equivalent parsers.
#
# Typical use:
#
#     export CODEQL_EXTRACTOR_UNIFIED_SWIFT_SYNTAX_PARSE=$(scripts/build-parser.sh)
#
# Progress output goes to stderr so that only the path lands on stdout.
set -euo pipefail
IFS=$'\n\t'

cd "$(dirname "$0")/.."

mode=bazel
case "${1:-}" in
    "" | --bazel) ;;
    --cargo) mode=cargo ;;
    *)
        echo "usage: $(basename "$0") [--bazel | --cargo]" >&2
        exit 2
        ;;
esac

if [[ $mode == cargo ]]; then
    cargo build -p swift-syntax-rs --bin swift-syntax-parse >&2
    # Cargo builds workspace members into the target directory at the
    # repository root, one level above this directory.
    echo "$(cd .. && pwd)/target/debug/swift-syntax-parse"
    exit 0
fi

# The wrapper script finds its Swift runtime libraries beside itself, so it only
# works in the flattened layout the installer produces; under `bazel-bin` and in
# the runfiles tree the libraries sit in a different directory.
dest=$PWD/target/swift-syntax-parse
bazel run //unified/swift-syntax-rs:install-parser -- --destdir "$dest" >&2
echo "$dest/swift-syntax-parse"
