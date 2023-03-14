#!/bin/bash
set -eux
CARGO=cargo
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  platform="linux64"
  if which cross; then
    CARGO=cross
  fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
  platform="osx64"
else
  echo "Unknown OS"
  exit 1
fi

(cd extractor && "$CARGO" build --release)
extractor/target/release/generator --dbscheme ql/lib/ruby.dbscheme --library ql/lib/codeql/ruby/ast/internal/TreeSitter.qll

codeql query format -i ql/lib/codeql/ruby/ast/internal/TreeSitter.qll

rm -rf extractor-pack
mkdir -p extractor-pack
cp -r codeql-extractor.yml downgrades tools ql/lib/ruby.dbscheme ql/lib/ruby.dbscheme.stats extractor-pack/
mkdir -p extractor-pack/tools/${platform}
cp extractor/target/release/extractor extractor-pack/tools/${platform}/extractor
cp extractor/target/release/autobuilder extractor-pack/tools/${platform}/autobuilder
