#!/bin/bash

if [[ -z "${CODEQL_POWERSHELL_EXTRACTOR}" ]]; then
  export CODEQL_POWERSHELL_EXTRACTOR="Semmle.Extraction.PowerShell.Standalone"
fi

"$CODEQL_EXTRACTOR_POWERSHELL_ROOT/tools/$CODEQL_PLATFORM/$CODEQL_POWERSHELL_EXTRACTOR" --file-list "%1"