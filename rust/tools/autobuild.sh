#!/bin/bash

exec "${CODEQL_DIST}/codeql" database index-files \
  --working-dir=. --language=rust --include-extension=.rs \
  ${CODEQL_VERBOSITY:+"--verbosity=${CODEQL_VERBOSITY}"} \
  "${CODEQL_EXTRACTOR_RUST_WIP_DATABASE}"
