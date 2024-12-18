#!/bin/bash

set -Eeuo pipefail # see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

set -x

CODEQL=${CODEQL:-codeql}

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "$SCRIPTDIR"

rm -rf db
rm -f *.actual

python3 make_test.py

echo "Testing database with various errors during extraction"
$CODEQL database create db --language python --source-root repo_dir/
$CODEQL query run --database db query.ql > query.actual
diff query.expected query.actual
python3 test_diagnostics_output.py

rm -f *.actual
rm -f repo_dir/recursion_error.py
rm -rf db
