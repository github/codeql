#!/bin/bash
set -Eeuo pipefail # see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

# Promotes new dataflow queries to be the real ones

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd $SCRIPTDIR
for file in $(find . -mindepth 2); do
    echo "Promoting $file"
    mkdir -p "../../Security/$(dirname $file)"
    mv "$file" "../../Security/${file}"
done
