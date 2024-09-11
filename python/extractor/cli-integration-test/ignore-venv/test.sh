#!/bin/bash

set -Eeuo pipefail # see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

set -x

CODEQL=${CODEQL:-codeql}

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "$SCRIPTDIR"

# start on clean slate
rm -rf dbs repo_dir/venv*
mkdir dbs


# set up venvs
cd repo_dir

# make venv with some package in it (so we show that our ignore logic is correct)
python3 -m venv venv
venv/bin/pip install flask

cd "$SCRIPTDIR"

export CODEQL_EXTRACTOR_PYTHON_DISABLE_AUTOMATIC_VENV_EXCLUDE=
$CODEQL database create dbs/normal --language python --source-root repo_dir/

export CODEQL_EXTRACTOR_PYTHON_DISABLE_AUTOMATIC_VENV_EXCLUDE=1
$CODEQL database create dbs/no-venv-ignore --language python --source-root repo_dir/

# ---

set +x

EXTRACTED_NORMAL=$(unzip -l dbs/normal/src.zip | wc -l)
EXTRACTED_NO_VENV_IGNORE=$(unzip -l dbs/no-venv-ignore/src.zip | wc -l)

exitcode=0

echo "EXTRACTED_NORMAL=$EXTRACTED_NORMAL"
echo "EXTRACTED_NO_VENV_IGNORE=$EXTRACTED_NO_VENV_IGNORE"

if [[ ! $EXTRACTED_NORMAL -lt $EXTRACTED_NO_VENV_IGNORE ]]; then
    echo "ERROR: EXTRACTED_NORMAL not smaller EXTRACTED_NO_VENV_IGNORE"
    exitcode=1
fi

exit $exitcode
