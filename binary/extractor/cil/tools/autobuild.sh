#!/bin/bash

set -eu

if [[ -z "${CODEQL_EXTRACTOR_CIL_ROOT:-}" ]]; then
  export CODEQL_EXTRACTOR_CIL_ROOT="$(dirname "$(dirname "${BASH_SOURCE[0]}")")"
fi

# For C# IL, autobuild and buildless extraction are the same - just extract the DLLs
exec "${CODEQL_EXTRACTOR_CIL_ROOT}/tools/index-files.sh"
