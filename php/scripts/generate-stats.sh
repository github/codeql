#!/bin/bash
set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
QL_LIB="$PROJECT_ROOT/ql/lib"
DBSCHEME="$QL_LIB/php.dbscheme"
STATS_FILE="$QL_LIB/php.dbscheme.stats"

# Determine mode from argument (default: basic)
MODE="${1:-basic}"
SOURCE_ROOT="${2:-.}"

# Validate mode
if [ "$MODE" != "basic" ] && [ "$MODE" != "advanced" ]; then
    echo "Error: Unknown mode '$MODE'. Use 'basic' or 'advanced'"
    exit 1
fi

echo "=== PHP CodeQL Stats Generation ($MODE mode) ==="
echo ""

# Build extractor if not already built
EXTRACTOR="$PROJECT_ROOT/extractor/target/release/codeql-extractor-php"
if [ ! -f "$EXTRACTOR" ]; then
    echo "Building Rust extractor..."
    cd "$PROJECT_ROOT/extractor"
    cargo build --release
    echo ""
fi

# Generate stats file
if [ "$MODE" = "basic" ]; then
    echo "Generating stats file (basic mode, heuristic-based)..."
    $EXTRACTOR stats-generate \
        --dbscheme "$DBSCHEME" \
        --stats-output "$STATS_FILE" \
        --mode basic
else
    echo "Generating stats file (advanced mode with source analysis)..."
    echo "Source root: $SOURCE_ROOT"
    $EXTRACTOR stats-generate \
        --dbscheme "$DBSCHEME" \
        --stats-output "$STATS_FILE" \
        --source-root "$SOURCE_ROOT" \
        --mode advanced
fi

echo ""
echo "✓ Stats file generated: $STATS_FILE"

# Show file info
if [ -f "$STATS_FILE" ]; then
    SIZE=$(wc -c < "$STATS_FILE")
    LINES=$(wc -l < "$STATS_FILE")
    echo "  Size: $SIZE bytes"
    echo "  Lines: $LINES"
else
    echo "✗ ERROR: Stats file was not created"
    exit 1
fi

echo "✓ Ready for CodeQL database finalization"
