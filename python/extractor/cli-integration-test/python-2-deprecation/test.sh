#!/bin/bash

set -Eeuo pipefail # see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

set -x

CODEQL=${CODEQL:-codeql}

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "$SCRIPTDIR"

rm -rf dbs
rm -f *.actual

mkdir dbs

# NB: on our Linux CI infrastructure, `python` is aliased to `python3`.
WITHOUT_PYTHON2=$(pwd)/without-python2
WITHOUT_PYTHON3=$(pwd)/without-python3

echo "Test 1: Only Python 2 is available. Should fail."
# Note the negation at the start of the command.
! PATH="$WITHOUT_PYTHON3:$PATH" $CODEQL database create dbs/only-python2-no-flag --language python --source-root repo_dir/

echo "Test 2: Only Python 3 is available. Should extract using Python 3 and use the Python 3 standard library."
PATH="$WITHOUT_PYTHON2:$PATH" $CODEQL database create dbs/without-python2 --language python --source-root repo_dir/
$CODEQL query run --database dbs/without-python2 query.ql > query.without-python2.actual
diff query.without-python2.expected query.without-python2.actual

echo "Test 3: Python 2 and 3 are both available. Should extract using Python 3, but use the Python 2 standard library."
$CODEQL database create dbs/python2-using-python3 --language python --source-root repo_dir/
$CODEQL query run --database dbs/python2-using-python3 query.ql > query.python2-using-python3.actual
diff query.python2-using-python3.expected query.python2-using-python3.actual

rm -f *.actual
