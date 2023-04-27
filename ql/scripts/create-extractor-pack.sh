#!/bin/bash
set -eux

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  platform="linux64"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  platform="osx64"
else
  echo "Unknown OS"
  exit 1
fi

if which codeql >/dev/null; then
  CODEQL_BINARY="codeql"
elif gh codeql >/dev/null; then
  CODEQL_BINARY="gh codeql"
else
  gh extension install github/gh-codeql
  CODEQL_BINARY="gh codeql"
fi

cargo build --release
cargo run --release --bin codeql-extractor-ql -- generate --dbscheme ql/src/ql.dbscheme --library ql/src/codeql_ql/ast/internal/TreeSitter.qll
$CODEQL_BINARY query format -i ql/src/codeql_ql/ast/internal/TreeSitter.qll

rm -rf extractor-pack
mkdir -p extractor-pack
cp -r codeql-extractor.yml tools ql/src/ql.dbscheme ql/src/ql.dbscheme.stats extractor-pack/
mkdir -p extractor-pack/tools/${platform}
cp target/release/codeql-extractor-ql extractor-pack/tools/${platform}/extractor
