#!/bin/bash

set -Eeuo pipefail # see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "$SCRIPTDIR"

failures=()
for f in */test.sh; do
    echo "Running $f:"
    if ! bash "$f"; then
        echo "ERROR: $f failed"
        failures+=("$f")
    fi
    echo "---"
done

if [ -z "${failures[*]}" ]; then
    echo "All integration tests passed!"
    exit 0
else
    echo "ERROR: Some integration test failed! Failures:"
    for failure in "${failures[@]}"
    do
        echo "- ${failure}"
    done
    exit 1
fi
