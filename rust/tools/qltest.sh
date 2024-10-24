#!/bin/bash

set -eu

export RUST_BACKTRACE=full

"$CODEQL_EXTRACTOR_RUST_ROOT/tools/$CODEQL_PLATFORM/extractor" --qltest
