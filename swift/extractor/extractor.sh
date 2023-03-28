#!/bin/bash

if [[ "$(uname)" == Darwin ]]; then
  export DYLD_LIBRARY_PATH=$(dirname "$0")
else
  export LD_LIBRARY_PATH=$(dirname "$0")
fi

exec -a "$0" "$0.real" "$@"
