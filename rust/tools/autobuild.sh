#!/bin/bash

exec "${CODEQL_DIST}/codeql" database index-files \
  --working-dir=. --language=rust --include-extension=.rs \
  "${CODEQL_EXTRACTOR_RUST_WIP_DATABASE}"
