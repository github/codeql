#!/bin/bash

set -eu

WORKSPACE_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )/.." &> /dev/null && pwd )

exec "$WORKSPACE_DIR/misc/bazel/3rdparty/update_tree_sitter_extractors_deps.sh"
