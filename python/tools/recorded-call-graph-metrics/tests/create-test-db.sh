#!/bin/bash

set -Eeuo pipefail # see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if ! pip show cg_trace &>/dev/null; then
    echo "You need to follow setup instructions in README"
    exit 1
fi

DB="$SCRIPTDIR/cg-trace-test-db"
SRC="$SCRIPTDIR/python-src/"
XMLDIR="$SCRIPTDIR/python-traces/"
PYTHON_EXTRACTOR=$(codeql resolve extractor --language=python)

rm -rf "$DB"
rm -rf "$XMLDIR"

mkdir -p "$XMLDIR"

for f in $(ls $SRC); do
    echo "Tracing $f"
    cg-trace --xml "$XMLDIR/${f%.py}.xml" "$SRC/$f"
done

codeql database init --source-root="$SRC" --language=python "$DB"
codeql database trace-command --working-dir="$SRC" "$DB" "$PYTHON_EXTRACTOR/tools/autobuild.sh"
codeql database index-files --language xml --include-extension .xml --working-dir="$XMLDIR" "$DB"
codeql database finalize "$DB"

echo "Created database '$DB'"
