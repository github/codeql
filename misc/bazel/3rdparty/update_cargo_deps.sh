#! /usr/bin/env bash

set -eu

"${BASH_SOURCE[0]}/update_py_deps.sh"
"${BASH_SOURCE[0]}/update_tree_sitter_extractors_deps.sh"
