#!/bin/sh
set -eu

if [ -n "${CODEQL_LUA_BYTECODE_INPUT_ROOT:-}" ]; then
  exec "${CODEQL_DIST}/codeql" database index-files \
    --language=lua \
    --include='**/*.luac' \
    --working-dir="$CODEQL_LUA_BYTECODE_INPUT_ROOT" \
    "$CODEQL_EXTRACTOR_LUA_WIP_DATABASE"
fi

"${CODEQL_DIST}/codeql" database index-files \
  --language=lua \
  --include='**/*.lua' \
  --working-dir="${LGTM_SRC:-$(pwd)}" \
  "$CODEQL_EXTRACTOR_LUA_WIP_DATABASE"
