#! /usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
MODE=${1:-install}
if [ "$MODE" != "install" ] && [ "$MODE" != "update" ]; then
    echo "Invalid mode: $MODE. Valid modes are 'install' and 'update'"
    exit 1
fi

(
    cd "$SCRIPT_DIR" || exit 1
    DEP_DIR="$(pwd)"
    (dotnet tool restore && dotnet paket $MODE) || exit 1
    cd ../..
    tools/bazel run @rules_dotnet//tools/paket2bazel -- --dependencies-file "$DEP_DIR"/paket.dependencies --output-folder "$DEP_DIR"
)
