#!/bin/bash

set -Eeuo pipefail # see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

set -x

CODEQL=${CODEQL:-codeql}

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "$SCRIPTDIR"

# start on clean slate
rm -rf dbs
mkdir dbs

cd "$SCRIPTDIR"

export CODEQL_EXTRACTOR_PYTHON_FORCE_ENABLE_LIBRARY_EXTRACTION_UNTIL_2_17_0=
$CODEQL database create dbs/normal --language python --source-root repo_dir/

export CODEQL_EXTRACTOR_PYTHON_FORCE_ENABLE_LIBRARY_EXTRACTION_UNTIL_2_17_0=1
$CODEQL database create dbs/with-lib-extraction --language python --source-root repo_dir/

# ---

set +x

EXTRACTED_NORMAL=$(unzip -l dbs/normal/src.zip | wc -l)
EXTRACTED_WITH_LIB_EXTRACTION=$(unzip -l dbs/with-lib-extraction/src.zip | wc -l)

exitcode=0

echo "EXTRACTED_NORMAL=$EXTRACTED_NORMAL"
echo "EXTRACTED_WITH_LIB_EXTRACTION=$EXTRACTED_WITH_LIB_EXTRACTION"

if [[ ! $EXTRACTED_WITH_LIB_EXTRACTION -gt $EXTRACTED_NORMAL ]]; then
    echo "ERROR: EXTRACTED_WITH_LIB_EXTRACTION not greater than EXTRACTED_NORMAL"
    exitcode=1
fi

exit $exitcode
