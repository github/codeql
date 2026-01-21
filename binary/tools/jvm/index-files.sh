#!/bin/bash

set -eu

exec dotnet "$CODEQL_EXTRACTOR_JVM_ROOT/tools/$CODEQL_PLATFORM/Semmle.Extraction.Java.ByteCode.dll" "$1"
