#!/bin/bash

set -eu

source misc/bazel/runfiles.sh 2>/dev/null || source external/ql+/misc/bazel/runfiles.sh

ast_generator="$(rlocation "$1")"
grammar_file="$(rlocation "$2")"
ast_generator_manifest="$(rlocation "$3")"
codegen="$(rlocation "$4")"
codegen_conf="$(rlocation "$5")"
rustfmt="$(rlocation "$6")"
shift 6

CARGO_MANIFEST_DIR="$(dirname "$ast_generator_manifest")" "$ast_generator" "$grammar_file"
"$rustfmt" "$(dirname "$ast_generator_manifest")/../extractor/src/translate/generated.rs"
"$codegen" --configuration-file="$codegen_conf" "$@"
