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

python3 -m venv venv
venv/bin/pip install flask

python3 -m venv venv2

cd "$SCRIPTDIR"

# In 2.16.0 we stop extracting libraries by default, so to test this functionality we
# need to force enable it. Once we release 2.17.0 and turn off library extraction for
# good, we can remove the part of this test ensuring that dependencies in an active
# venv are still extracted (since that will no longer be the case).
export CODEQL_EXTRACTOR_PYTHON_FORCE_ENABLE_LIBRARY_EXTRACTION_UNTIL_2_17_0=1

# Create DBs with venv2 active (that does not have flask installed)
source repo_dir/venv2/bin/activate

export CODEQL_EXTRACTOR_PYTHON_DISABLE_AUTOMATIC_VENV_EXCLUDE=
$CODEQL database create dbs/normal --language python --source-root repo_dir/

export CODEQL_EXTRACTOR_PYTHON_DISABLE_AUTOMATIC_VENV_EXCLUDE=1
$CODEQL database create dbs/no-venv-ignore --language python --source-root repo_dir/

# Create DB with venv active that has flask installed. We want to ensure that we're
# still able to resolve imports to flask, but don't want to extract EVERYTHING from
# within the venv. Important note is that the test-file in the repo_dir actually imports
# flask :D
source repo_dir/venv/bin/activate
export CODEQL_EXTRACTOR_PYTHON_DISABLE_AUTOMATIC_VENV_EXCLUDE=
$CODEQL database create dbs/normal-with-flask-venv --language python --source-root repo_dir/

# ---

set +x

EXTRACTED_NORMAL=$(unzip -l dbs/normal/src.zip | wc -l)
EXTRACTED_NO_VENV_IGNORE=$(unzip -l dbs/no-venv-ignore/src.zip | wc -l)
EXTRACTED_ACTIVE_FLASK=$(unzip -l dbs/normal-with-flask-venv/src.zip | wc -l)

exitcode=0

echo "EXTRACTED_NORMAL=$EXTRACTED_NORMAL"
echo "EXTRACTED_NO_VENV_IGNORE=$EXTRACTED_NO_VENV_IGNORE"
echo "EXTRACTED_ACTIVE_FLASK=$EXTRACTED_ACTIVE_FLASK"

if [[ ! $EXTRACTED_NORMAL -lt $EXTRACTED_NO_VENV_IGNORE ]]; then
    echo "ERROR: EXTRACTED_NORMAL not smaller EXTRACTED_NO_VENV_IGNORE"
    exitcode=1
fi

if [[ ! $EXTRACTED_NORMAL -lt $EXTRACTED_ACTIVE_FLASK ]]; then
    echo "ERROR: EXTRACTED_NORMAL not smaller EXTRACTED_ACTIVE_FLASK"
    exitcode=1
fi

if [[ ! $EXTRACTED_ACTIVE_FLASK -lt $EXTRACTED_NO_VENV_IGNORE ]]; then
    echo "ERROR: EXTRACTED_ACTIVE_FLASK not smaller EXTRACTED_NO_VENV_IGNORE"
    exitcode=1
fi

exit $exitcode
