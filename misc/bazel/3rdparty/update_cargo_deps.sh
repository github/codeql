#! /usr/bin/env bash

set -eu

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )


"$SCRIPT_DIR/update_py_deps.sh"
"$SCRIPT_DIR/update_tree_sitter_extractors_deps.sh"
