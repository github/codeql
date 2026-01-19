#! /usr/bin/env bash

set -eu

WORKSPACE_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )/../../.." &> /dev/null && pwd )

cd "$WORKSPACE_DIR"
time bazel run //misc/bazel/3rdparty:vendor_ruby_deps

bazel mod tidy
