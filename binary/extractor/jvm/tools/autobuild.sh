#!/bin/bash

set -eu

# Find all .class and .jar files and create a file list
find "$CODEQL_EXTRACTOR_JVM_SOURCE_ARCHIVE_DIR/../src" -name "*.class" -o -name "*.jar" > "$CODEQL_EXTRACTOR_JVM_ROOT/files.txt" 2>/dev/null || true

# If source root is set, also search there
if [[ -n "${LGTM_SRC:-}" ]]; then
    find "$LGTM_SRC" -name "*.class" -o -name "*.jar" >> "$CODEQL_EXTRACTOR_JVM_ROOT/files.txt" 2>/dev/null || true
fi

# Index each file
if [[ -s "$CODEQL_EXTRACTOR_JVM_ROOT/files.txt" ]]; then
    while IFS= read -r file; do
        if [[ -f "$file" ]]; then
            "$CODEQL_EXTRACTOR_JVM_ROOT/tools/index-files.sh" "$file" || true
        fi
    done < "$CODEQL_EXTRACTOR_JVM_ROOT/files.txt"
fi

echo "JVM extractor: indexing complete"
