#!/bin/bash

SCRIPT_DIR="$(dirname "$0")"

if [[ -n "$CODEQL_JAVA_HOME" ]]; then
  JAVA="$CODEQL_JAVA_HOME/bin/java"
else
  JAVA=java
fi

"$JAVA" -cp "$SCRIPT_DIR/ke2.jar" KotlinExtractorKt "$@"
