#!/bin/bash

if [[ "$OSTYPE" == "darwin"* ]]; then
  exec "${CODEQL_EXTRACTOR_SWIFT_ROOT}/tools/${CODEQL_PLATFORM}/xcode-autobuilder"
else
  echo "Not implemented yet"
  exit 1
fi
