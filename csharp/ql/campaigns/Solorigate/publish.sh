#!/bin/sh

set -e

SOLORIGATE_ROOT="$(dirname $0)"
WORKSPACE_ROOT="$SOLORIGATE_ROOT/../../../.."
GROUPS="solorigate,-test"

if [ -z "$CODEQL_DIST" ]; then
  echo "CODEQL_DIST not set"
  exit -1
fi

cd "$SOLORIGATE_ROOT"
echo Testing solorigate queries
"${CODEQL_DIST}/codeql" test run test

cd "$WORKSPACE_ROOT"

ech Preparing release
"${CODEQL_DIST}/codeql" codeql pack release --groups $GROUPS

echo Publishing solorigate
"${CODEQL_DIST}/codeql" pack publish --dry-run --groups $GROUPS

echo Bumping versions
"${CODEQL_DIST}/codeql" pack post-release --groups $GROUPS

echo Solorigate packs successfully published. Please commit and push the version changes.
