#!/bin/sh

set -eu

"$CODEQL_DIST/codeql" database index-files \
    --include-extension=.config \
    --include-extension=.csproj \
    --include-extension=.props \
    --include-extension=.xml \
    --size-limit 10m \
    --language xml \
    -- \
    "$CODEQL_EXTRACTOR_CSHARP_WIP_DATABASE"

"$CODEQL_JAVA_HOME/bin/java" -jar "$CODEQL_EXTRACTOR_CSHARP_ROOT/tools/extractor-asp.jar" .
