#!/bin/bash

set -eu

"$CODEQL_DIST/codeql" database index-files --working-dir=. --language=cil "$CODEQL_EXTRACTOR_CIL_WIP_DATABASE"
