#!/bin/bash

set -Eeuo pipefail # see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

set -x

CODEQL=${CODEQL:-codeql}

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "$SCRIPTDIR"

rm -rf db

# even with default encoding that doesn't support utf-8 (like on windows) we want to
# ensure that we can properly log that we've extracted files whose filenames contain
# utf-8 chars
export PYTHONIOENCODING="ascii"
$CODEQL database create db --language python --source-root repo_dir/
