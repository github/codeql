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

"$CARGO" build --release

"$CARGO" run --release -p ruby-generator -- --dbscheme ql/lib/ruby.dbscheme --library ql/lib/codeql/ruby/ast/internal/TreeSitter.qll
codeql query format -i ql/lib/codeql/ruby/ast/internal/TreeSitter.qll

rm -rf extractor-pack
mkdir -p extractor-pack
cp -r codeql-extractor.yml downgrades tools ql/lib/ruby.dbscheme ql/lib/ruby.dbscheme.stats extractor-pack/
mkdir -p extractor-pack/tools/${platform}
cp target/release/ruby-extractor extractor-pack/tools/${platform}/extractor
cp target/release/ruby-autobuilder extractor-pack/tools/${platform}/autobuilder
