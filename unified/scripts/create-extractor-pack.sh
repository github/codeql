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
cd "$(dirname "$0")/.."

(cd extractor && cargo build --release)

# we are in a cargo workspace rooted at the git checkout
BIN_DIR=../target/release
"$BIN_DIR/codeql-extractor-unified" generate --dbscheme ql/lib/unified.dbscheme --library ql/lib/codeql/unified/Ast.qll

codeql query format -i ql/lib/codeql/unified/Ast.qll

rm -rf extractor-pack
mkdir -p extractor-pack
cp -r codeql-extractor.yml tools ql/lib/unified.dbscheme ql/lib/unified.dbscheme.stats extractor-pack/
mkdir -p extractor-pack/tools/${platform}
cp "$BIN_DIR/codeql-extractor-unified" extractor-pack/tools/${platform}/extractor
