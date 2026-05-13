#!/bin/bash
# Regenerate the vendored tree-sitter-swift parser tables from grammar.js,
# then refresh the human-readable node-types.yml companion file.
#
# Run this after editing
# unified/extractor/tree-sitter-swift/grammar.js so that:
#   * src/parser.c, src/grammar.json, src/node-types.json (and the
#     src/tree_sitter/*.h headers) reflect the current grammar; and
#   * node-types.yml shows the same information in a form that's
#     pleasant to review in PR diffs.
#
# Requirements: tree-sitter CLI on PATH, and a working cargo toolchain.
set -euo pipefail

cd "$(dirname "$0")/.."
SWIFT_DIR="extractor/tree-sitter-swift"

(
    cd "$SWIFT_DIR"
    tree-sitter generate
)

# Build yeast's node_types_yaml binary and use it to convert the freshly
# generated src/node-types.json into the human-readable node-types.yml.
cargo run --release --quiet -p yeast --bin node_types_yaml -- \
    --from-json "$SWIFT_DIR/src/node-types.json" > "$SWIFT_DIR/node-types.yml"

echo "Regenerated $SWIFT_DIR/{src/parser.c,src/grammar.json,src/node-types.json,node-types.yml}"
