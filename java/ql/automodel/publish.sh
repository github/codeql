#!/bin/bash
set -e

# Add help message
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  echo "Usage: ./publish [override-release]"
  echo "By default we publish the version of the codeql repo specified by the latest official release defined by the codeml-automodel repo."
  echo "Otherwise, the optional argument override-release forces your current HEAD to be published."
  exit 0
fi

# Check that either there are 0 or 1 arguments, and if 1 argument then check that it is "override-release"
if [ $# -gt 1 ] || [ $# -eq 1 ] && [ "$1" != "override-release" ]; then
  echo "Error: Invalid arguments. Please run './publish --help' for usage information."
  exit 1
fi

# If we're publishing the codeml-automodel release then we will checkout the sha specified in the release.
# So we need to check that there are no uncommitted changes in the local branch.
# And, if we're publishing the current HEAD, it's cleaner to ensure that there are no uncommitted changes.
if ! git diff --quiet; then
  echo "Error: Uncommitted changes exist. Please commit or stash your changes before publishing."
  exit 1
fi

# Check the above environment variables are set
if [ -z "${GITHUB_TOKEN}" ]; then
  echo "Error: GITHUB_TOKEN environment variable not set. Please set this to a token with package:write permissions to codeql."
  exit 1
fi
if [ -z "${CODEQL_DIST}" ]; then
  echo "Error: CODEQL_DIST environment variable not set. Please set this to the path of a codeql distribution."
  exit 1
fi
if [ -z "${GH_TOKEN}" ]; then
  echo "Error: GH_TOKEN environment variable not set. Please set this to a token with repo permissions to github/codeml-automodel."
  exit 1
fi

# Get the sha of the previous release, i.e. the last commit to the main branch that updated the query pack version
PREVIOUS_RELEASE_SHA=$(git rev-list -n 1 main -- ./src/qlpack.yml)
if [ -z "$PREVIOUS_RELEASE_SHA" ]; then
  echo "Error: Could not get the sha of the previous release of codeml-automodel query pack"
  exit 1
else
  echo "Previous query-pack release sha: $PREVIOUS_RELEASE_SHA"
fi

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
CURRENT_SHA=$(git rev-parse HEAD)

if [ -z "${1:-}" ]; then
  # If the first argument is empty, use the latest release of codeml-automodel
  TAG_NAME=$(gh api -H 'Accept: application/vnd.github+json' -H 'X-GitHub-Api-Version: 2022-11-28' /repos/github/codeml-automodel/releases/latest | jq -r .tag_name)
  # Check TAG_NAME is not empty
  if [ -z "$TAG_NAME" ]; then
      echo "Error: Could not get latest release of codeml-automodel"
      exit 1
  fi
  echo "Updating to latest automodel release: $TAG_NAME"
  # Before downloading, delete any existing release.zip, and ignore failure if not present
  rm release.zip || true
  gh release download $TAG_NAME -A zip -O release.zip --repo 'https://github.com/github/codeml-automodel'
  # Before unzipping, delete any existing release directory, and ignore failure if not present
  rm -rf release || true
  unzip -o release.zip -d release 
  REVISION=$(jq -r '.["codeql-sha"]' release/codeml-automodel*/codeml-automodel-release.json)
  echo "The latest codeml-automodel release specifies the codeql sha $REVISION"
  # Check that REVISION is downstream from PREVIOUS_RELEASE_SHA
  if ! git merge-base --is-ancestor "$PREVIOUS_RELEASE_SHA" "$REVISION"; then
    echo "Error: The codeql version $REVISION is not downstream of the query-pack version $PREVIOUS_RELEASE_SHA"
    exit 1
  fi
  # Get the version of the codeql code specified by the codeml-automodel release
  git checkout "$REVISION"
else
  # Check that the current HEAD is downstream from PREVIOUS_RELEASE_SHA
  if ! git merge-base --is-ancestor "$PREVIOUS_RELEASE_SHA" "$CURRENT_SHA"; then
    echo "Error: The current HEAD is not downstream from the previous release"
    exit 1
  fi
fi

# Get the absolute path of the automodel repo
AUTOMODEL_ROOT="$(readlink -f "$(dirname $0)")"
# Get the absolute path of the workspace root
WORKSPACE_ROOT="$AUTOMODEL_ROOT/../../.."
# Specify the groups of queries to test and publish
GRPS="automodel,-test"

pushd "$AUTOMODEL_ROOT"
echo Testing automodel queries
"${CODEQL_DIST}/codeql" test run test
popd

pushd "$WORKSPACE_ROOT"
echo "Preparing the release"
"${CODEQL_DIST}/codeql" pack release --groups $GRPS -v

echo "Publishing the release"
# Add --dry-run to test publishing
"${CODEQL_DIST}/codeql" pack publish --groups $GRPS -v

echo "Bumping versions"
"${CODEQL_DIST}/codeql" pack post-release --groups $GRPS -v
popd

# The above commands update
#  ./src/CHANGELOG.md
#  ./src/codeql-pack.release.yml
#  ./src/qlpack.yml
# and add a new file
#  ./src/change-notes/released/<version>.md

if [ -z "${1:-}" ]; then
  # If we used the latest release of codeml-automodel, then we need to return to the current branch
  git checkout "$CURRENT_BRANCH"
fi

# Add the updated files to the current branch
git add ./src/CHANGELOG.md
git add ./src/codeql-pack.release.yml
git add ./src/qlpack.yml
git add ./src/change-notes/released/*
echo "Added the following updated version files to the current branch:"
git status -s

echo "Automodel packs successfully published. Local files have been modified. Please commit and push the version changes and then merge into main."

