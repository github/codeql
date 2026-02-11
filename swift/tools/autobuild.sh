#!/bin/bash

if [[ "$OSTYPE" == "darwin"* ]]; then
  export CODEQL_SWIFT_CARTHAGE_EXEC=`which carthage`
  export CODEQL_SWIFT_POD_EXEC=`which pod`
  exec "${CODEQL_EXTRACTOR_SWIFT_ROOT}/tools/${CODEQL_PLATFORM}/swift-autobuilder"
else
  exec "${CODEQL_EXTRACTOR_SWIFT_ROOT}/tools/${CODEQL_PLATFORM}/incompatible-os"
fi
