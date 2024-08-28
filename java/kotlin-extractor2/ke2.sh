#!/bin/bash

SCRIPT_DIR="$(dirname "$0")"

# This default should be kept in sync with
# com.semmle.extractor.java.interceptors.KotlinInterceptor.initializeExtractionContext
TRAP_DIR="$CODEQL_EXTRACTOR_JAVA_TRAP_DIR"
if [ "$TRAP_DIR" = "" ]
then
    TRAP_DIR="kotlin-extractor/trap"
fi
mkdir -p "$TRAP_DIR"

INVOCATION_TRAP=`mktemp -p "$TRAP_DIR" invocation.XXXXXXXXXX.trap`

echo "// Invocation of Kotlin Extractor 2" >> "$INVOCATION_TRAP"
echo "#compilation = *" >> "$INVOCATION_TRAP"
# TODO: This should be properly escaped:
echo "compilations(#compilation, 2, \"`pwd`\",\"$INVOCATION_TRAP\")" >> "$INVOCATION_TRAP"
ARG_INDEX=0
for ARG in "$@"
do
    # TODO: This should be properly escaped:
    echo "compilation_args(#compilation, $ARG_INDEX, \"$ARG\")" >> "$INVOCATION_TRAP"
    ARG_INDEX=$(("$ARG_INDEX" + 1))
done

if [[ -n "$CODEQL_JAVA_HOME" ]]; then
  JAVA="$CODEQL_JAVA_HOME/bin/java"
else
  JAVA=java
fi

"$JAVA" -Xmx2G -cp "$SCRIPT_DIR/ke2.jar" com.github.codeql.KotlinExtractorKt "$INVOCATION_TRAP" "$@"
