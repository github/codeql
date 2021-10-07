#!/bin/bash

# Installs any necessary QL pack dependencies from the package registry.
# The optional argument must be a valid value for the `--mode` option to `codeql pack install`

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
GO_ROOT=$(dirname "$SCRIPT_DIR")

if [ $# -eq 0 ]; then
    LOCK_MODE="use-lock"
elif [ $# -eq 1 ]; then
    LOCK_MODE=$1
else
    echo "Usage: install-deps.sh [<lock-mode>]"
    echo "  lock-mode: One of 'use-lock' (default), 'verify', 'update', or 'no-lock'"
    exit 1
fi

codeql pack install --mode ${LOCK_MODE} "${GO_ROOT}/ql/lib"
codeql pack install --mode ${LOCK_MODE} "${GO_ROOT}/ql/src"
codeql pack install --mode ${LOCK_MODE} "${GO_ROOT}/ql/test"
codeql pack install --mode ${LOCK_MODE} "${GO_ROOT}/ql/examples"
codeql pack install --mode ${LOCK_MODE} "${GO_ROOT}/upgrades"
