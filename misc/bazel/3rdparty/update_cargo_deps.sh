#! /usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

(
    cd "$SCRIPT_DIR" || exit 1
    cd ../../../
    time bazel run //misc/bazel/3rdparty:vendor_py_deps
    bazel mod tidy
    time bazel run //misc/bazel/3rdparty:vendor_rust_deps
    bazel mod tidy
    time bazel run //misc/bazel/3rdparty:vendor_ruby_deps
    bazel mod tidy
)
