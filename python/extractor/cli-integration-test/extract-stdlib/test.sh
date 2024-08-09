#!/bin/bash

set -Eeuo pipefail # see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

set -x

CODEQL=${CODEQL:-codeql}

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "$SCRIPTDIR"

rm -rf dbs

mkdir dbs

$CODEQL database create dbs/without-stdlib --language python --source-root repo_dir/
$CODEQL query run --database dbs/without-stdlib query.ql > query.without-stdlib.actual
diff query.without-stdlib.expected query.without-stdlib.actual

LGTM_INDEX_EXCLUDE="/usr/lib/**" CODEQL_EXTRACTOR_PYTHON_EXTRACT_STDLIB=True $CODEQL database create dbs/with-stdlib --language python --source-root repo_dir/
$CODEQL query run --database dbs/with-stdlib query.ql > query.with-stdlib.actual
diff query.with-stdlib.expected query.with-stdlib.actual
