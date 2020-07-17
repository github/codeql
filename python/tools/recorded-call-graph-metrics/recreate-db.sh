#!/bin/bash

set -e
set -x

if ! pip show cg_trace; then
    echo "You need to follow setup instructions in README"
    exit 1
fi

DB="cg-trace-example-db"
SRC="example/"
XMLDIR="example-traces/"
PYTHON_EXTRACTOR=$(codeql resolve extractor --language=python)


cg-trace --xml "$XMLDIR"/simple.xml example/simple.py
cg-trace --xml "$XMLDIR"/builtins.xml example/builtins.py

rm -rf "$DB"


codeql database init --source-root="$SRC" --language=python "$DB"
codeql database trace-command --working-dir="$SRC" "$DB" "$PYTHON_EXTRACTOR/tools/autobuild.sh"
codeql database index-files --language xml --include-extension .xml --working-dir="$XMLDIR" "$DB"
codeql database finalize "$DB"

set +x
echo "Created database '$DB'"
