#! /usr/bin/env bash

set -eu

WORKSPACE_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )/../../.." &> /dev/null && pwd )

cd "$WORKSPACE_DIR"
time bazel run //misc/bazel/3rdparty:vendor_tree_sitter_extractors

# we need access to this file in the rust extractor
echo 'exports_files(["rust.ungram"])' >> misc/bazel/3rdparty/tree_sitter_extractors_deps/BUILD.ra_ap_syntax-?.*.bazel

# no idea why this is necessary, see https://github.com/bazelbuild/rules_rust/issues/3255
python3 "$WORKSPACE_DIR/misc/bazel/3rdparty/patch_defs.py" misc/bazel/3rdparty/tree_sitter_extractors_deps/defs.bzl

bazel mod tidy
