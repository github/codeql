#!/bin/sh

set -eu

export RUST_BACKTRACE=1
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

exec /usr/bin/env python3 "${SCRIPT_DIR}/autobuild.py"