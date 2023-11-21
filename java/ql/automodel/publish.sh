#!/bin/sh
set -e

# Before running this, make sure there is an SSO-enabled token with package:write
# permissions to codeql supplied via the GITHUB_TOKEN environment variable

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
