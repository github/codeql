#!/bin/bash

set -eu

if [[ -z "${CODEQL_CIL_EXTRACTOR:-}" ]]; then
    CODEQL_CIL_EXTRACTOR=Semmle.Extraction.CSharp.IL
fi

exec dotnet "$CODEQL_EXTRACTOR_CIL_ROOT/tools/$CODEQL_PLATFORM/$CODEQL_CIL_EXTRACTOR.dll" "$1"
