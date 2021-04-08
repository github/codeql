#!/bin/bash

set -e
set -x

DB="cg-trace-example-db"
SRC="example/"
XMLDIR="$SRC"
PYTHON_EXTRACTOR=$(codeql resolve extractor --language=python)


./cg_trace.py --xml example/simple.xml example/simple.py

rm -rf "$DB"


codeql database init --source-root="$SRC" --language=python "$DB"
codeql database trace-command --working-dir="$SRC" "$DB" "$PYTHON_EXTRACTOR/tools/autobuild.sh"
codeql database index-files --language xml --include-extension .xml --working-dir="$XMLDIR" "$DB"
codeql database finalize "$DB"

set +x
echo "Created database '$DB'"
