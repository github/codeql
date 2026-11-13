#!/bin/bash

set -eu

WORKSPACE_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )/.." &> /dev/null && pwd )

exec "$WORKSPACE_DIR/misc/bazel/3rdparty/update_rust_workspace_deps.sh"
