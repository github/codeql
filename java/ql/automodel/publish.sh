#!/bin/sh
set -e

AUTOMODEL_ROOT="$(readlink -f "$(dirname $0)")"
WORKSPACE_ROOT="$AUTOMODEL_ROOT/../../.."
GRPS="automodel,-test"

if [ -z "$CODEQL_DIST" ]; then
  echo "CODEQL_DIST not set"
  exit -1
fi

cd "$AUTOMODEL_ROOT"
echo Testing automodel queries
"${CODEQL_DIST}/codeql" test run test

cd "$WORKSPACE_ROOT"

echo Preparing release
"${CODEQL_DIST}/codeql" pack release --groups $GRPS

echo Publishing automodel
"${CODEQL_DIST}/codeql" pack publish --groups $GRPS

echo Bumping versions
"${CODEQL_DIST}/codeql" pack post-release --groups $GRPS

echo Automodel packs successfully published. Please commit and push the version changes.
