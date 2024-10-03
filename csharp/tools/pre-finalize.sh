#!/bin/bash

set -eu

if [ "${ENABLE_BUILDLESS:-true}" == "true" ]; then

NO_GENERATED_SOURCES=true
SOURCE_ROOT=$(cat "${CODEQL_EXTRACTOR_CSHARP_WIP_DATABASE}/codeql-database.yml" | grep sourceLocationPrefix: | sed 's/sourceLocationPrefix: //')

# revert changes in the source tree
(cd "${SOURCE_ROOT}"; git checkout HEAD .)

# delete all source files from the source tree
find "${SOURCE_ROOT}" -type f -name '*.cs' -delete

# restore C# files from the source archive
(cd "$CODEQL_EXTRACTOR_CSHARP_WIP_DATABASE/src/${SOURCE_ROOT}"; find . -type f -name '*.cs' -print0 | tar cf - --null --files-from - ) | tar xf - -C "${SOURCE_ROOT}"

# git clean source files, `bin` and `obj`` folders and possibly added dll or exe files that were outside `bin` or `obj` folders
(cd "${SOURCE_ROOT}"; git clean -fdx '*.cs' '**/*.cs' '*.dll' '*.exe' '**/*.dll' '**/*.exe' 'bin/' 'obj/' '**/bin/' '**/obj/')

# find config file
if [ -e "${CODEQL_EXTRACTOR_CSHARP_WIP_DATABASE}/working/config.json" ]; then
 CONFIG_FILE="--codescanning-config=$(jq -r .originalLocation "${CODEQL_EXTRACTOR_CSHARP_WIP_DATABASE}/working/config.json")"
fi

# delete database
rm -rf "$CODEQL_EXTRACTOR_CSHARP_WIP_DATABASE"

# initialize database
"$CODEQL_DIST/codeql" database init --language=csharp --source-root="${SOURCE_ROOT}" "$CODEQL_EXTRACTOR_CSHARP_WIP_DATABASE" \
  --extractor-include-aliases ${CONFIG_FILE+"${CONFIG_FILE}"} --calculate-language-specific-baseline \
  --sublanguage-file-coverage

# run in buildless mode
env CODEQL_EXTRACTOR_CSHARP_OPTION_BUILDLESS=true "$CODEQL_DIST/codeql" database trace-command "$CODEQL_EXTRACTOR_CSHARP_WIP_DATABASE" -- "$CODEQL_DIST/csharp/tools/autobuild.sh"
fi

"$CODEQL_DIST/codeql" database index-files \
    --include-extension=.config \
    --include-extension=.csproj \
    --include-extension=.props \
    --include-extension=.xml \
    --size-limit 10m \
    --language xml \
    --working-dir=. \
    -- \
    "$CODEQL_EXTRACTOR_CSHARP_WIP_DATABASE" \
    > /dev/null 2>&1

"$CODEQL_JAVA_HOME/bin/java" -jar "$CODEQL_EXTRACTOR_CSHARP_ROOT/tools/extractor-asp.jar" .
