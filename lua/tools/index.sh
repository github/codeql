#!/bin/sh
set -eu

exec python3 "$CODEQL_EXTRACTOR_LUA_ROOT/tools/index_lua_files.py" \
  --source-root "$(pwd)" \
  --source-archive-dir "$CODEQL_EXTRACTOR_LUA_SOURCE_ARCHIVE_DIR" \
  --output-dir "$CODEQL_EXTRACTOR_LUA_TRAP_DIR"
