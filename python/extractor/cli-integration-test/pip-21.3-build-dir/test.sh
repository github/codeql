#!/bin/bash

set -Eeuo pipefail # see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

set -x

CODEQL=${CODEQL:-codeql}

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "$SCRIPTDIR"

NUM_PYTHON_FILES_IN_REPO=$(find repo_dir/src/ -name '*.py' | wc -l)

rm -rf venv dbs

mkdir dbs

python3 -m venv venv

source venv/bin/activate

pip install --upgrade 'pip>=21.3'

cd repo_dir
pip install .
cd "$SCRIPTDIR"

export CODEQL_EXTRACTOR_PYTHON_DISABLE_AUTOMATIC_PIP_BUILD_DIR_EXCLUDE=
$CODEQL database create dbs/normal --language python --source-root repo_dir/

export CODEQL_EXTRACTOR_PYTHON_DISABLE_AUTOMATIC_PIP_BUILD_DIR_EXCLUDE=1
$CODEQL database create dbs/with-build-dir --language python --source-root repo_dir/

EXTRACTED_NORMAL=$(unzip -l dbs/normal/src.zip | wc -l)
EXTRACTED_WITH_BUILD=$(unzip -l dbs/with-build-dir/src.zip | wc -l)

if [[ $((EXTRACTED_NORMAL + NUM_PYTHON_FILES_IN_REPO)) == $EXTRACTED_WITH_BUILD ]]; then
    echo "Numbers add up"
else
    echo "Numbers did not add up"
    echo "NUM_PYTHON_FILES_IN_REPO=$NUM_PYTHON_FILES_IN_REPO"
    echo "EXTRACTED_NORMAL=$EXTRACTED_NORMAL"
    echo "EXTRACTED_WITH_BUILD=$EXTRACTED_WITH_BUILD"
    exit 1
fi
