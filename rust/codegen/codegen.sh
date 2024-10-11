#!/bin/bash

set -eu

source misc/bazel/runfiles.sh 2>/dev/null || source external/ql+/misc/bazel/runfiles.sh

ast_generator="$(rlocation "$1")"
ast_generator_manifest="$(rlocation "$2")"
codegen="$(rlocation "$3")"
codegen_conf="$(rlocation "$4")"

CARGO_MANIFEST_DIR="$(dirname "$ast_generator_manifest")" "$ast_generator"
"$codegen" --configuration-file="$codegen_conf"
