#!/bin/bash

set -eu

"$CODEQL_DIST/codeql" database index-files --working-dir=. --language=jvm "$CODEQL_EXTRACTOR_JVM_WIP_DATABASE"
