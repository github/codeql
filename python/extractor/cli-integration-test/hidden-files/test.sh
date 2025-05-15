#!/bin/bash

set -Eeuo pipefail # see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

set -x

CODEQL=${CODEQL:-codeql}

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "$SCRIPTDIR"

rm -rf db db-skipped

# Test 1: Default behavior should be to extract files in hidden directories
$CODEQL database create db --language python --source-root repo_dir/
$CODEQL query run --database db query.ql > query-default.actual
diff query-default.expected query-default.actual

# Test 2: The default behavior can be overridden by setting `paths-ignore` in the config file
$CODEQL database create db-skipped --language python --source-root repo_dir/ --codescanning-config=config.yml
$CODEQL query run --database db-skipped query.ql > query-skipped.actual
diff query-skipped.expected query-skipped.actual

rm -rf db db-skipped
