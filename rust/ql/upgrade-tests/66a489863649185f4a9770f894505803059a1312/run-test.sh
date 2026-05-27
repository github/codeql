#!/usr/bin/env bash
# Manual regression test for the Rust dbscheme upgrade from rust-analyzer 0.0.301 to 0.0.328.
# See README.md for details.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(git rev-parse --show-toplevel)"
OLD_COMMIT="${OLD_COMMIT:-491c373e076}"  # origin/main at time of this upgrade
OLD_DBSCHEME="rust/downgrades/109496fd2f20f28a35e50b110859e74882ee80d6/rust.dbscheme"

cd "$REPO_ROOT"

# Require clean working directory - stash handling is too fragile
if ! git diff --quiet HEAD || [ -n "$(git ls-files --others --exclude-standard)" ]; then
    echo "ERROR: Working directory has uncommitted changes." >&2
    echo "Please commit or stash your changes before running this test." >&2
    exit 1
fi

ORIGINAL_REF="$(git rev-parse --abbrev-ref HEAD)"
if [ "$ORIGINAL_REF" = "HEAD" ]; then
    # Detached HEAD - save the commit instead
    ORIGINAL_REF="$(git rev-parse HEAD)"
fi

restore_ref() {
    echo "==> Restoring original ref ($ORIGINAL_REF)..."
    git checkout --quiet "$ORIGINAL_REF"
}
trap 'restore_ref' EXIT

echo "==> Checking out old commit ($OLD_COMMIT)..."
git checkout --quiet "$OLD_COMMIT"

# Restore the upgrade-tests directory from the original ref (it doesn't exist in old commit)
git checkout --quiet "$ORIGINAL_REF" -- rust/ql/upgrade-tests codeql-workspace.yml

echo "==> Building old extractor (this may take a while)..."
bazel run //rust:install

echo "==> Creating old-schema test database..."
codeql test run \
    --search-path . \
    --keep-databases \
    "$SCRIPT_DIR/old.ql" "$@"

restore_ref
trap '' EXIT

echo "==> Upgrading dataset to new schema..."
DATASET_DIR=("$SCRIPT_DIR"/*.testproj/db-rust)
if [[ ! -d "${DATASET_DIR[0]}" ]]; then
    echo "ERROR: No testproj found at $SCRIPT_DIR/*.testproj" >&2
    exit 1
fi
codeql dataset upgrade "${DATASET_DIR[0]}" \
    --search-path . \
    --target-dbscheme rust/ql/lib/rust.dbscheme

echo "==> Running preservation test on upgraded dataset..."
codeql test run \
    --search-path . \
    --dataset "${DATASET_DIR[0]}" \
    --check-databases \
    "$SCRIPT_DIR/new.ql" "$@"

echo "==> Downgrading dataset back to old schema..."
codeql dataset upgrade "${DATASET_DIR[0]}" \
    --allow-downgrades \
    --search-path rust \
    --target-dbscheme "$OLD_DBSCHEME"

trap 'restore_ref' EXIT

echo "==> Checking out old commit ($OLD_COMMIT) for downgrade verification..."
git checkout --quiet "$OLD_COMMIT"
git checkout --quiet "$ORIGINAL_REF" -- rust/ql/upgrade-tests codeql-workspace.yml

echo "==> Running preservation test on downgraded dataset..."
codeql test run \
    --search-path . \
    --dataset "${DATASET_DIR[0]}" \
    --check-databases \
    "$SCRIPT_DIR/downgraded.ql" "$@"

restore_ref
trap '' EXIT

echo "==> All tests passed!"
