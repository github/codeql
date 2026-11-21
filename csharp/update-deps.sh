#! /usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
MODE=${1:-install}
if [ "$MODE" != "install" ] && [ "$MODE" != "update" ]; then
    echo "Invalid mode: $MODE. Valid modes are 'install' and 'update'"
    exit 1
fi

(
    cd "$SCRIPT_DIR" || exit 1
    dotnet tool restore && dotnet paket "$MODE"
)
