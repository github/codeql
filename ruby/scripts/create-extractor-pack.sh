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

# If building via cross, the binaries will be in extractor/target/<triple>/release
# If building via cargo, the binaries will be in extractor/target/release
BIN_DIR=extractor/target/release
if [[ "$CARGO" == "cross" ]]; then
  BIN_DIR=extractor/target/x86_64-unknown-linux-gnu/release
fi

"$BIN_DIR/generator" --dbscheme ql/lib/ruby.dbscheme --library ql/lib/codeql/ruby/ast/internal/TreeSitter.qll

codeql query format -i ql/lib/codeql/ruby/ast/internal/TreeSitter.qll

rm -rf extractor-pack
mkdir -p extractor-pack
cp -r codeql-extractor.yml downgrades tools ql/lib/ruby.dbscheme ql/lib/ruby.dbscheme.stats extractor-pack/
mkdir -p extractor-pack/tools/${platform}
cp "$BIN_DIR/extractor" extractor-pack/tools/${platform}/extractor
cp "$BIN_DIR/autobuilder" extractor-pack/tools/${platform}/autobuilder
