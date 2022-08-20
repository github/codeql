#!/bin/sh
set -e

SOLORIGATE_ROOT="$(dirname $0)"
WORKSPACE_ROOT="$SOLORIGATE_ROOT/../../../.."
GRPS="solorigate,-test"

if [ -z "$CODEQL_DIST" ]; then
  echo "CODEQL_DIST not set"
  exit -1
fi

cd "$SOLORIGATE_ROOT"
echo Testing solorigate queries
"${CODEQL_DIST}/codeql" test run test

cd "$WORKSPACE_ROOT"

echo Preparing release
"${CODEQL_DIST}/codeql" pack release --groups $GRPS

echo Publishing solorigate
"${CODEQL_DIST}/codeql" pack publish --groups $GRPS

echo Bumping versions
"${CODEQL_DIST}/codeql" pack post-release --groups $GRPS

echo Solorigate packs successfully published. Please commit and push the version changes.
