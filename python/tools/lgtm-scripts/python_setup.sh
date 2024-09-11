#! /bin/bash

set -eu

python "${CODEQL_EXTRACTOR_PYTHON_ROOT}/tools/setup.py" || true
