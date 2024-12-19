#! /usr/bin/env bash

set -eu

WORKSPACE_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )/../../.." &> /dev/null && pwd )

cd "$WORKSPACE_DIR"
time bazel run //misc/bazel/3rdparty:vendor_tree_sitter_extractors

# we need access to this file in the rust extractor
echo 'exports_files(["rust.ungram"])' >> misc/bazel/3rdparty/tree_sitter_extractors_deps/BUILD.ra_ap_syntax-?.*.bazel

bazel mod tidy
