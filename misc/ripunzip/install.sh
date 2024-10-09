#!/bin/bash

set -eu

source misc/bazel/runfiles.sh 2>/dev/null || source external/ql+/misc/bazel/runfiles.sh

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
