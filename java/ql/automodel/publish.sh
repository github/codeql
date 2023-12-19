#!/bin/sh
set -e

# Before running this, make sure
# 1. there is an SSO-enabled token with package:write permissions to codeql supplied via the GITHUB_TOKEN environment variable
# 2. the CODEQL_DIST environment variable is set to the path of a codeql distribution
# 3. the gh command line tool is installed and authenticated with a token that has repo permissions to github/codeml-automodel
# supplied via the GH_TOKEN environment variable

# Script to publish a new version of the automodel package to the package registry.
# Usage: ./publish [override-release]
# By default the sha of the codeql repo specified in the latest release of codeml-automodel will be published.
# Otherwise, the optional argument override-release forces the current HEAD to be published.

# If the first argument is empty, use the latest release of codeml-automodel
if [ -z "${1:-}" ]; then
    TAG_NAME=$(gh api -H 'Accept: application/vnd.github+json' -H 'X-GitHub-Api-Version: 2022-11-28' /repos/github/codeml-automodel/releases/latest | jq -r .tag_name)
    # Check TAG_NAME is not empty
    if [ -z "$TAG_NAME" ]; then
        echo "Error: Could not get latest release of codeml-automodel"
        exit 1
    fi
    echo "Updating to latest automodel release: $TAG_NAME"
    rm release.zip || true
    gh release download $TAG_NAME -A zip -O release.zip --repo 'https://github.com/github/codeml-automodel'
    unzip -o release.zip -d release 
    REVISION=$(jq -r '.["codeql-sha"]' release/codeml-automodel*/codeml-automodel-release.json)
    echo "The latest automodel release specifies a codeql revision of $REVISION"
    if git diff --quiet; then
      echo "Checking out CodeQL revision $REVISION"
      git reset --hard "$REVISION"
    else
      echo "Error: Uncommitted changes exist. Please commit or stash your changes before resetting."
      exit 1
    fi
fi

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
