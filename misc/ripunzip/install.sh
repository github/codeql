#!/bin/bash

set -eu

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


dest="${2:-$HOME/.local/bin}"

if [ ! -d "$dest" ]; then
  echo "$dest: not a directory. Provide a valid installation target." >&2
  exit 1
fi

source="$(rlocation "$1")"

dest+="/ripunzip"

if [[ "$source" = *.exe ]]; then
  dest+=".exe"
fi

cp "$source" "$dest"

echo "installed $("$dest" --version) in $(dirname "$dest")"
