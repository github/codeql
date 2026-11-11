#! /usr/bin/env bash

# Temporary script that forwards to update_all_rust_deps.sh. Remove once all
# references to this script has been removed.

set -eu

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

exec "$SCRIPT_DIR/update_all_rust_deps.sh" "$@"
