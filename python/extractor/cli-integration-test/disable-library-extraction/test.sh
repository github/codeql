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

# In 2.16.0 we will not extract libraries by default, so there is no difference in what
# is extracted by setting this environment variable.. We should remove this test when
# 2.17.0 is released.
export CODEQL_EXTRACTOR_PYTHON_DISABLE_LIBRARY_EXTRACTION=
$CODEQL database create dbs/normal --language python --source-root repo_dir/

export CODEQL_EXTRACTOR_PYTHON_DISABLE_LIBRARY_EXTRACTION=1
$CODEQL database create dbs/no-lib-extraction --language python --source-root repo_dir/

# ---

set +x

EXTRACTED_NORMAL=$(unzip -l dbs/normal/src.zip | wc -l)
EXTRACTED_NO_LIB_EXTRACTION=$(unzip -l dbs/no-lib-extraction/src.zip | wc -l)

exitcode=0

echo "EXTRACTED_NORMAL=$EXTRACTED_NORMAL"
echo "EXTRACTED_NO_LIB_EXTRACTION=$EXTRACTED_NO_LIB_EXTRACTION"

if [[ $EXTRACTED_NO_LIB_EXTRACTION -lt $EXTRACTED_NORMAL ]]; then
    echo "ERROR: EXTRACTED_NO_LIB_EXTRACTION smaller than EXTRACTED_NORMAL"
    exitcode=1
fi

exit $exitcode
