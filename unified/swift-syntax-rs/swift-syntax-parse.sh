#!/bin/bash

# Wrapper that lets the shipped `swift-syntax-parse` find its Swift runtime
# libraries, which are packaged in the same directory as this script (and the
# real binary). Mirrors `swift/extractor/extractor.sh`.
if [[ "$(uname)" == Darwin ]]; then
  export DYLD_LIBRARY_PATH=$(dirname "$0")
else
  export LD_LIBRARY_PATH=$(dirname "$0")
fi

exec -a "$0" "$0.real" "$@"
