#!/bin/sh

set -eu

# Legacy environment variables for the autobuild infrastructure.
LGTM_SRC="$(pwd)"
LGTM_WORKSPACE="$CODEQL_EXTRACTOR_PYTHON_SCRATCH_DIR"
export LGTM_SRC
export LGTM_WORKSPACE

if which python3 >/dev/null; then
    exec python3 "$CODEQL_EXTRACTOR_PYTHON_ROOT/tools/index.py"
elif which python >/dev/null; then
    exec python "$CODEQL_EXTRACTOR_PYTHON_ROOT/tools/index.py"
else
    echo "ERROR: Could not find a valid Python distribution. It should be available when running 'which python' or 'which python3' in your shell. Python 2 is no longer supported."
    exit 1
fi
