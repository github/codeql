#! /usr/bin/env bash

set -eu

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )


"$SCRIPT_DIR/update_py_deps.sh"
"$SCRIPT_DIR/update_ruby_deps.sh"
"$SCRIPT_DIR/update_rust_deps.sh"
