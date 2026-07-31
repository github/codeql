#!/bin/bash
# Regenerate `extractor/swift_node_types.yml`, the schema describing the shape
# of the trees `swift-syntax-parse` emits, from swift-syntax itself.
#
# Run this after changing the pinned swift-syntax version, and review the diff:
# a new or renamed node kind generally means the mapping in
# `extractor/src/languages/swift/swift.rs` needs attention too.
#
# Unlike the parser, this needs a local Swift toolchain (see
# `swift-syntax-rs/.swift-version` for the pinned version). The schema it
# derives from lives in `SyntaxSupport`, a target of swift-syntax's separate
# `CodeGeneration` package: it is not a product of swift-syntax, and Bazel's
# swift-syntax module does not export its sources, so there is no way to depend
# on it — hence the copy below.
set -euo pipefail
IFS=$'\n\t'

cd "$(dirname "$0")/.."

ffi_dir=swift-syntax-rs/swift
schemagen_dir=swift-syntax-rs/schemagen
output=extractor/swift_node_types.yml

# `schemagen` takes swift-syntax as a path dependency on this checkout, so that
# the schema describes exactly the version the parser links.
echo "Resolving swift-syntax..." >&2
swift package --package-path "$ffi_dir" resolve >&2
checkout=$ffi_dir/.build/checkouts/swift-syntax
syntax_support=$checkout/CodeGeneration/Sources/SyntaxSupport
if [[ ! -d $syntax_support ]]; then
    echo "error: $syntax_support not found after resolving swift-syntax." >&2
    exit 1
fi

# Refresh rather than merge, so that sources deleted upstream do not linger.
rm -rf "$schemagen_dir/Sources/SyntaxSupport"
cp -r "$syntax_support" "$schemagen_dir/Sources/SyntaxSupport"

echo "Generating $output..." >&2
# Generate to a temporary file first: redirecting straight into `$output` would
# truncate the existing schema before the build has even run, leaving nothing
# behind if it fails.
tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT
swift run --package-path "$schemagen_dir" schemagen > "$tmp"
if [[ ! -s $tmp ]]; then
    echo "error: schemagen produced no output; $output left unchanged." >&2
    exit 1
fi
mv "$tmp" "$output"
chmod 644 "$output"
echo "Regenerated $output" >&2
