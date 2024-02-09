#!/bin/bash
set -e

help="Usage: ./publish [--override-release] [--dry-run]
Publish the automodel query pack.

If no arguments are provided, publish the version of the codeql repo specified by the latest official release of the codeml-automodel repo.
If the --override-release argument is provided, your current local HEAD is used (for unofficial releases or patching).
If the --dry-run argument is provided, the release is not published (for testing purposes)."

# Echo the help message
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  echo "$help"
  exit 0
fi

# Check the number of arguments are valid
if [ $# -gt 2 ]; then
  echo "Error: Invalid arguments provided"
  echo "$help"
  exit 1
fi

OVERRIDE_RELEASE=0
DRY_RUN=0
for arg in "$@"
do
  case $arg in
    --override-release)
    OVERRIDE_RELEASE=1
    shift # Remove --override-release from processing
    ;;
    --dry-run)
    DRY_RUN=1
    shift # Remove --dry-run from processing
    ;;
    *)
    echo "Error: Invalid argument provided: $arg"
    echo "$help"
    exit 1
    ;;
  esac
done

# Describe what we're about to do based on the command-line arguments
if [ $OVERRIDE_RELEASE = 1 ]; then
  echo "Publishing the current HEAD of the automodel repo"
else
  echo "Publishing the version of the automodel repo specified by the latest official release of the codeml-automodel repo"
fi
if [ $DRY_RUN = 1 ]; then
  echo "Dry run: we will step through the process but we won't publish the query pack"
else
  echo "Not a dry run! Publishing the query pack"
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

if [ $OVERRIDE_RELEASE = 1 ]; then
  # Check that the current HEAD is downstream from PREVIOUS_RELEASE_SHA
  if ! git merge-base --is-ancestor "$PREVIOUS_RELEASE_SHA" "$CURRENT_SHA"; then
    echo "Error: The current HEAD is not downstream from the previous release"
    exit 1
  fi
else
  # Get the latest release of codeml-automodel
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
fi

# Get the absolute path of the automodel repo
AUTOMODEL_ROOT="$(readlink -f "$(dirname $0)")"
# Get the absolute path of the workspace root
WORKSPACE_ROOT="$AUTOMODEL_ROOT/../../.."
# Specify the groups of queries to test and publish
GRPS="automodel,-test"

# Install the codeql gh extension
gh extensions install github/gh-codeql

pushd "$AUTOMODEL_ROOT"
echo Testing automodel queries
gh codeql test run test
popd

pushd "$WORKSPACE_ROOT"
echo "Preparing the release"
gh codeql pack release --groups $GRPS -v

if [ $DRY_RUN = 1 ]; then
  echo "Dry run: not publishing the query pack"
  gh codeql pack publish --groups $GRPS --dry-run -v
else
  echo "Not a dry run! Publishing the query pack"
  gh codeql pack publish --groups $GRPS -v
fi

echo "Bumping versions"
gh codeql pack post-release --groups $GRPS -v
popd

# The above commands update
#  ./src/CHANGELOG.md
#  ./src/codeql-pack.release.yml
#  ./src/qlpack.yml
# and add a new file
#  ./src/change-notes/released/<version>.md

# Get the filename of the most recently created file in ./src/change-notes/released/*.md
# This will be the file for the new release
NEW_CHANGE_NOTES_FILE=$(ls -t ./src/change-notes/released/*.md | head -n 1)

# Make a copy of the modified files
mv ./src/CHANGELOG.md ./src/CHANGELOG.md.dry-run
mv ./src/codeql-pack.release.yml ./src/codeql-pack.release.yml.dry-run
mv ./src/qlpack.yml ./src/qlpack.yml.dry-run
mv "$NEW_CHANGE_NOTES_FILE" ./src/change-notes/released.md.dry-run

if [ $OVERRIDE_RELEASE = 1 ]; then
  # Restore the original files
  git checkout ./src/CHANGELOG.md
  git checkout ./src/codeql-pack.release.yml
  git checkout ./src/qlpack.yml
else
  # Restore the original files
  git checkout "$CURRENT_BRANCH" --force
fi

if [ $DRY_RUN = 1 ]; then
  echo "Inspect the updated dry-run version files:"
  ls -l ./src/*.dry-run
  ls -l ./src/change-notes/*.dry-run
else
  # Add the updated files to the current branch
  echo "Adding the version changes"
  mv -f ./src/CHANGELOG.md.dry-run ./src/CHANGELOG.md
  mv -f ./src/codeql-pack.release.yml.dry-run ./src/codeql-pack.release.yml
  mv -f ./src/qlpack.yml.dry-run ./src/qlpack.yml
  mv -f ./src/change-notes/released.md.dry-run "$NEW_CHANGE_NOTES_FILE"
  git add ./src/CHANGELOG.md
  git add ./src/codeql-pack.release.yml
  git add ./src/qlpack.yml
  git add "$NEW_CHANGE_NOTES_FILE"
  echo "Added the following updated version files to the current branch:"
  git status -s
  echo "To complete the release, please commit these files and merge to the main branch"
fi

echo "Done"