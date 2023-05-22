#!/bin/bash

if [[ "$OSTYPE" == "darwin"* ]]; then
  exec "${CODEQL_EXTRACTOR_SWIFT_ROOT}/tools/${CODEQL_PLATFORM}/xcode-autobuilder"
else
  exec "${CODEQL_EXTRACTOR_SWIFT_ROOT}/tools/${CODEQL_PLATFORM}/incompatible-os"
fi
