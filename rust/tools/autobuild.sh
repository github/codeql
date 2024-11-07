#!/bin/bash

export RUST_BACKTRACE=1
exec "${CODEQL_DIST}/codeql" database index-files \
  --working-dir=. --language=rust --include-extension=.rs \
  "${CODEQL_EXTRACTOR_RUST_WIP_DATABASE}"
