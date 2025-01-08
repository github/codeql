#!/bin/bash

set -eu

source misc/bazel/runfiles.sh 2>/dev/null || source external/ql+/misc/bazel/runfiles.sh

ast_generator="$(rlocation "$1")"
grammar_file="$(rlocation "$2")"
ast_generator_manifest="$(rlocation "$3")"
codegen="$(rlocation "$4")"
codegen_conf="$(rlocation "$5")"
shift 5

CARGO_MANIFEST_DIR="$(dirname "$ast_generator_manifest")" "$ast_generator" "$grammar_file"
"$codegen" --configuration-file="$codegen_conf" "$@"
