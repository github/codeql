#!/usr/bin/env bash
# Manual regression test for the Rust dbscheme upgrade from rust-analyzer 0.0.301 to 0.0.328.
# See README.md for details.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../../../.." && pwd)"
OLD_COMMIT="${OLD_COMMIT:-491c373e076}"  # origin/main at time of this upgrade

cd "$REPO_ROOT"

echo "==> Setting up temp directory for old test..."
OLD_TEST_TMP=$(mktemp -d)
trap 'rm -rf "$OLD_TEST_TMP"' EXIT

# Copy old test query and new test sources (qlpack, upgrade_shapes.rs) to temp
cp "$SCRIPT_DIR/old/OldShapes.ql" "$SCRIPT_DIR/old/OldShapes.expected" "$OLD_TEST_TMP/"
cp "$SCRIPT_DIR/new/qlpack.yml" "$SCRIPT_DIR/new/upgrade_shapes.rs" "$OLD_TEST_TMP/"

echo "==> Stashing any uncommitted changes..."
git stash --quiet || true

restore_branch() {
    echo "==> Restoring original branch..."
    git checkout --quiet -
    git stash pop --quiet 2>/dev/null || true
}
trap 'restore_branch; rm -rf "$OLD_TEST_TMP"' EXIT

echo "==> Checking out old commit ($OLD_COMMIT)..."
git checkout --quiet "$OLD_COMMIT"

echo "==> Building old extractor (this may take a while)..."
bazel run //rust:install

echo "==> Creating old-schema test database..."
rm -rf "$OLD_TEST_TMP"/*.testproj
codeql test run \
    --search-path . \
    --keep-databases \
    "$OLD_TEST_TMP/OldShapes.ql"

echo "==> Copying dataset for upgrade..."
cp -a "$OLD_TEST_TMP/test.testproj/db-rust" "$OLD_TEST_TMP/upgraded-dataset"

restore_branch
trap 'rm -rf "$OLD_TEST_TMP"' EXIT

echo "==> Upgrading dataset to new schema..."
codeql dataset upgrade "$OLD_TEST_TMP/upgraded-dataset" \
    --search-path . \
    --target-dbscheme rust/ql/lib/rust.dbscheme

echo "==> Running preservation test on upgraded dataset..."
codeql test run \
    --search-path . \
    --dataset="$OLD_TEST_TMP/upgraded-dataset" \
    --check-databases \
    "$SCRIPT_DIR/new/UpgradeShapes.ql"

echo "==> All tests passed!"
