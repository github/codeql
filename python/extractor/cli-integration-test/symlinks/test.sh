#!/bin/bash

set -Eeuo pipefail # see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

set -x

CODEQL=${CODEQL:-codeql}

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "$SCRIPTDIR"

rm -rf db

# create two symlink loops, so
# - repo_dir/subdir/symlink_to_top -> repo_dir
# - repo_dir/symlink_to_top -> repo_dir
# such a setup was seen in https://github.com/PowerDNS/weakforced

rm -rf repo_dir/subdir
mkdir repo_dir/subdir
ln -s .. repo_dir/subdir/symlink_to_top

rm -f repo_dir/symlink_to_top
ln -s . repo_dir/symlink_to_top

timeout --verbose 15s $CODEQL database create db --language python --source-root repo_dir/
$CODEQL query run --database db query.ql
