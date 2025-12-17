#!/bin/bash
set -eux

if [[ -f "$HOME/.cargo/env" ]]; then
  . "$HOME/.cargo/env"
fi

CODEQL_BIN="codeql"
if [[ -x "$(cd "$(dirname "$0")/.." && pwd)/../.codeql-cli/codeql/codeql" ]]; then
  CODEQL_BIN="$(cd "$(dirname "$0")/.." && pwd)/../.codeql-cli/codeql/codeql"
elif [[ -n "${CODEQL_DIST:-}" ]]; then
  CODEQL_BIN="${CODEQL_DIST}/codeql"
fi
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

BIN_DIR=../target/release
"$BIN_DIR/codeql-extractor-php" generate --dbscheme ql/lib/php.dbscheme --library ql/lib/codeql/php/ast/internal/TreeSitter.qll

"$CODEQL_BIN" query format -i ql/lib/codeql/php/ast/internal/TreeSitter.qll

rm -rf extractor-pack
mkdir -p extractor-pack
cp -r codeql-extractor.yml tools ql/lib/php.dbscheme ql/lib/php.dbscheme.stats extractor-pack/

# The repo's tools directory should not normally contain platform-specific binaries.
# Remove any that may exist locally (for example from ad-hoc testing) before
# installing the freshly built extractor binary.
rm -rf extractor-pack/tools/*64 || true

mkdir -p extractor-pack/tools/${platform}
cp -f "$BIN_DIR/codeql-extractor-php" extractor-pack/tools/${platform}/extractor
chmod +x extractor-pack/tools/${platform}/extractor
