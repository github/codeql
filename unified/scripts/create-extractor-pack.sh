#!/bin/bash
# Build the extractor pack into `extractor-pack/`, ready for
# `codeql test run --search-path extractor-pack`.
#
# `unified.dbscheme` and `Ast.qll` are generated from `extractor/ast_types.yml`,
# so they are regenerated here before the pack is assembled.
set -euo pipefail
IFS=$'\n\t'

cd "$(dirname "$0")/.."
root=$PWD

# `bazel run` executes from the runfiles tree, so pass absolute output paths.
bazel run //unified/extractor -- generate \
    --dbscheme "$root/ql/lib/unified.dbscheme" \
    --library "$root/ql/lib/codeql/unified/Ast.qll"

codeql query format -i ql/lib/codeql/unified/Ast.qll

rm -rf extractor-pack
exec bazel run //unified:install "$@"
