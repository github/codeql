#!/bin/bash
# Regenerate `extractor/swift_node_types.yml`, the schema describing the shape
# of the trees produced by `swift_syntax_rs::parse_to_json`, from swift-syntax
# itself.
#
# Run this after changing the pinned swift-syntax version, and review the diff:
# a new or renamed node kind generally means the mapping in
# `extractor/src/languages/swift/swift.rs` needs attention too.
#
# This needs a local Swift toolchain (see `swift-syntax-rs/.swift-version` for
# the pinned version). The schema it derives from lives in `SyntaxSupport`, a
# target of swift-syntax's separate `CodeGeneration` package: it is not a
# product of swift-syntax, and Bazel's swift-syntax module does not export its
# sources, so there is no way to depend on it directly.
set -euo pipefail
IFS=$'\n\t'

root=$(cd "$(dirname "$0")/.." && pwd)
swift_syntax_rs_dir="$root/swift-syntax-rs"
schemagen_dir="$swift_syntax_rs_dir/schemagen"
output="$root/extractor/swift_node_types.yml"

if ! command -v swift >/dev/null 2>&1; then
    echo "error: Swift is required; install the version pinned in $swift_syntax_rs_dir/.swift-version." >&2
    exit 1
fi

# Codespaces sets `safe.bareRepository=explicit` through environment-based Git
# configuration, which prevents SwiftPM from using its cached bare dependency
# repositories. Relax only that injected setting, and only for Swift
# subprocesses, as `swift-syntax-rs/build.rs` does for local Cargo builds.
run_swift() {
    if [[ ${GIT_CONFIG_KEY_0:-} == "safe.bareRepository" ]]; then
        GIT_CONFIG_VALUE_0=all swift "$@"
    else
        swift "$@"
    fi
}

echo "Resolving swift-syntax..." >&2
(
    cd "$schemagen_dir"
    run_swift package resolve >&2
)
checkout="$schemagen_dir/.build/checkouts/swift-syntax"
syntax_support="$checkout/CodeGeneration/Sources/SyntaxSupport"
if [[ ! -d $syntax_support ]]; then
    echo "error: $syntax_support not found after resolving swift-syntax." >&2
    exit 1
fi

# Refresh rather than merge, so that sources deleted upstream do not linger.
rm -rf "$schemagen_dir/Sources/SyntaxSupport"
cp -R "$syntax_support" "$schemagen_dir/Sources/SyntaxSupport"

echo "Generating $output..." >&2
# Generate to a temporary file first: redirecting straight into `$output` would
# truncate the existing schema before the build has even run, leaving nothing
# behind if it fails.
tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT
(
    cd "$schemagen_dir"
    run_swift run schemagen
) > "$tmp"
if [[ ! -s $tmp ]]; then
    echo "error: schemagen produced no output; $output left unchanged." >&2
    exit 1
fi
mv "$tmp" "$output"
chmod 644 "$output"
echo "Regenerated $output" >&2
