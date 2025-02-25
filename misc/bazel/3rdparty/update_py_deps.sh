#! /usr/bin/env bash

set -eu

WORKSPACE_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )/../../.." &> /dev/null && pwd )

cd "$WORKSPACE_DIR"
time bazel run //misc/bazel/3rdparty:vendor_py_deps
# no idea why this is necessary, see https://github.com/bazelbuild/rules_rust/issues/3255
python3 "$WORKSPACE_DIR/misc/bazel/3rdparty/patch_defs.py" misc/bazel/3rdparty/py_deps/defs.bzl
bazel mod tidy
