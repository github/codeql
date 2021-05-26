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

cargo build --release

cargo run --release -p ql-generator
codeql query format -i ql/src/codeql_ql/ast/internal/TreeSitter.qll

rm -rf extractor-pack
mkdir -p extractor-pack
cp -r codeql-extractor.yml tools ql/src/ql.dbscheme ql/src/ql.dbscheme.stats extractor-pack/
mkdir -p extractor-pack/tools/${platform}
cp target/release/ql-extractor extractor-pack/tools/${platform}/extractor
