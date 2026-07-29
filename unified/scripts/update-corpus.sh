#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

cd "$(dirname "$0")/.."

# The corpus is produced by the external swift-syntax parser. That parser is a
# separate crate which `cargo test` does not build (the extractor deliberately
# does not depend on it, so working on other languages needs no Swift
# toolchain), so build it up front — otherwise the tests below fail on a
# missing binary. This defaults to Bazel's hermetic Swift toolchain; pass
# `--cargo` to use a local one instead.
CODEQL_EXTRACTOR_UNIFIED_SWIFT_SYNTAX_PARSE=$(scripts/build-parser.sh "$@")
export CODEQL_EXTRACTOR_UNIFIED_SWIFT_SYNTAX_PARSE

cd extractor
UNIFIED_UPDATE_CORPUS=1 cargo test
