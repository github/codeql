#!/usr/bin/bash

# --- begin runfiles.bash initialization v3 ---
# Copy-pasted from the Bazel Bash runfiles library v3.
set -uo pipefail; set +e; f=bazel_tools/tools/bash/runfiles/runfiles.bash
source "${RUNFILES_DIR:-/dev/null}/$f" 2>/dev/null || \
  source "$(grep -sm1 "^$f " "${RUNFILES_MANIFEST_FILE:-/dev/null}" | cut -f2- -d' ')" 2>/dev/null || \
  source "$0.runfiles/$f" 2>/dev/null || \
  source "$(grep -sm1 "^$f " "$0.runfiles_manifest" | cut -f2- -d' ')" 2>/dev/null || \
  source "$(grep -sm1 "^$f " "$0.exe.runfiles_manifest" | cut -f2- -d' ')" 2>/dev/null || \
  { echo>&2 "ERROR: cannot find $f"; exit 1; }; f=; set -e
# --- end runfiles.bash initialization v3 ---

set -e

# the original working directory is not preserved anywhere, but needs to be accessible, as
# all paths are relative to this
# unfortunately, we need to change the working directory to run npm.
BAZEL_ROOT="$(pwd)"
RUNFILES_ROOT="$BAZEL_ROOT/$(rlocation .)"
SRC="$RUNFILES_ROOT/ql/javascript/extractor/lib/typescript"

# we need a temp dir, and unfortunately, $TMPDIR is not set on Windows
export TEMP=$(mktemp -d)

function find_tool() {
  # head -1 as there are two identical instances for external tools: semmle_code/external/<...> and <...>
  find "$RUNFILES_ROOT" -not -type d -name "$1" -or -name "$1.exe" | head -1
}

OUT="$BAZEL_ROOT/$1"
NPM="$(find_tool npm-cli.js)"
NODE_DIR="$(dirname "$(find_tool node)")"
ZIPPER="$(find_tool zipper)"
RULEDIR="$(dirname "$OUT")"

# clean up
rm -rf "$RULEDIR/inputs"
rm -f "$OUT"

# Add node to the path so that npm run can find it - it's calling env node
export PATH="$NODE_DIR:$PATH"
# npm has a global cache which doesn't work on macos, where absolute paths aren't filtered out by the sandbox.
# Therefore, set a temporary cache directory.
export NPM_CONFIG_USERCONFIG="$TEMP/npmrc"
"$NPM" config set cache "$TEMP/npm"
"$NPM" config set update-notifier false

cp -L -R "$SRC" "$RULEDIR/inputs"
cd "$RULEDIR/inputs"
# remove this assembler script
rm compile compile.sh
"$NPM" install
"$NPM" run build
rm -rf node_modules
# Install again with only runtime deps
"$NPM" install --prod
mv node_modules build/
mkdir -p javascript/tools/typescript-parser-wrapper
mv build/* javascript/tools/typescript-parser-wrapper

if which cygpath &> /dev/null; then
  OUT="$(cygpath -w "$OUT")"
fi

"$ZIPPER" cC "$OUT" $(find javascript -name '*' -print)
