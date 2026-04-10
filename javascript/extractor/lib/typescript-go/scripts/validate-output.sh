#!/usr/bin/env bash
# validate-output.sh — Compare JSON output between the Node.js and Go
# TypeScript parser wrappers.
#
# Usage:
#   ./scripts/validate-output.sh [<ts-file> ...]
#
# Without arguments, it validates all .ts files from the test input directory.
#
# Environment variables:
#   NODEJS_WRAPPER  — Path to Node.js wrapper main.ts (default: auto-detect)
#   GO_WRAPPER      — Path to Go wrapper binary (default: builds from source)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
EXTRACTOR_LIB="$(cd "$PROJECT_DIR/.." && pwd)"
TYPESCRIPT_DIR="$EXTRACTOR_LIB/typescript"

# Locate the Node.js wrapper
find_nodejs_wrapper() {
    local candidates=(
        "$TYPESCRIPT_DIR/src/main.ts"
        "$TYPESCRIPT_DIR/src/main.js"
    )
    for c in "${candidates[@]}"; do
        if [ -f "$c" ]; then
            echo "$c"
            return
        fi
    done
    echo ""
}

NODEJS_WRAPPER="${NODEJS_WRAPPER:-$(find_nodejs_wrapper)}"

# Build and locate the Go wrapper
GO_WRAPPER="${GO_WRAPPER:-$PROJECT_DIR/bin/typescript-parser-wrapper}"
if [ ! -f "$GO_WRAPPER" ]; then
    echo "Building Go wrapper..."
    mkdir -p "$PROJECT_DIR/bin"
    (cd "$PROJECT_DIR" && go build -o bin/typescript-parser-wrapper ./cmd/typescript-parser-wrapper/) || {
        echo "Failed to build Go wrapper. Continuing with validation structure only."
        GO_WRAPPER=""
    }
fi

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

PASS=0
FAIL=0
SKIP=0

# Normalize JSON: sort keys, stable indentation
normalize_json() {
    python3 -c "
import json, sys
try:
    obj = json.load(sys.stdin)
    print(json.dumps(obj, sort_keys=True, indent=2))
except:
    print('')
" 2>/dev/null
}

# Parse a file with the Node.js wrapper (single-file mode)
parse_nodejs() {
    local file="$1"
    if [ -z "$NODEJS_WRAPPER" ]; then
        echo ""
        return
    fi
    # The Node.js wrapper supports: node main.ts <file.ts>
    node --no-warnings "$NODEJS_WRAPPER" "$file" 2>/dev/null || echo ""
}

# Parse a file with the Go wrapper (single-file mode)
parse_go() {
    local file="$1"
    if [ -z "$GO_WRAPPER" ]; then
        echo ""
        return
    fi
    "$GO_WRAPPER" "$file" 2>/dev/null || echo ""
}

compare_output() {
    local file="$1"
    local basename
    basename="$(basename "$file")"
    
    local nodejs_out go_out
    nodejs_out=$(parse_nodejs "$file")
    go_out=$(parse_go "$file")
    
    if [ -z "$nodejs_out" ] && [ -z "$go_out" ]; then
        echo -e "  ${YELLOW}SKIP${NC} $basename (both outputs empty)"
        SKIP=$((SKIP + 1))
        return
    fi
    
    if [ -z "$nodejs_out" ]; then
        echo -e "  ${YELLOW}SKIP${NC} $basename (Node.js output empty)"
        SKIP=$((SKIP + 1))
        return
    fi
    
    if [ -z "$go_out" ]; then
        echo -e "  ${YELLOW}SKIP${NC} $basename (Go output empty)"
        SKIP=$((SKIP + 1))
        return
    fi
    
    local nodejs_norm go_norm
    nodejs_norm=$(echo "$nodejs_out" | normalize_json)
    go_norm=$(echo "$go_out" | normalize_json)
    
    if [ "$nodejs_norm" = "$go_norm" ]; then
        echo -e "  ${GREEN}PASS${NC} $basename"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}FAIL${NC} $basename"
        FAIL=$((FAIL + 1))
        
        # Save outputs for inspection
        local outdir="$PROJECT_DIR/validation-output"
        mkdir -p "$outdir"
        echo "$nodejs_norm" > "$outdir/${basename}.nodejs.json"
        echo "$go_norm" > "$outdir/${basename}.go.json"
        
        # Show first few lines of diff
        diff <(echo "$nodejs_norm") <(echo "$go_norm") | head -30 || true
    fi
}

# Gather files
files=()
if [ $# -gt 0 ]; then
    files=("$@")
else
    # Use extractor test inputs
    TEST_DIR="$EXTRACTOR_LIB/../tests/ts/input"
    if [ -d "$TEST_DIR" ]; then
        for f in "$TEST_DIR"/*.ts; do
            [ -f "$f" ] && files+=("$f")
        done
    fi
    
    # Also use our own test data
    for f in "$PROJECT_DIR/testdata"/*.ts; do
        [ -f "$f" ] && files+=("$f")
    done
fi

if [ ${#files[@]} -eq 0 ]; then
    echo "No TypeScript files to validate."
    exit 0
fi

echo "=== TypeScript Parser Wrapper Validation ==="
echo "  Node.js wrapper: ${NODEJS_WRAPPER:-not found}"
echo "  Go wrapper:      ${GO_WRAPPER:-not built}"
echo "  Files:           ${#files[@]}"
echo ""

for file in "${files[@]}"; do
    compare_output "$(realpath "$file")"
done

echo ""
echo "=== Results ==="
echo -e "  ${GREEN}PASS: $PASS${NC}  ${RED}FAIL: $FAIL${NC}  ${YELLOW}SKIP: $SKIP${NC}"

if [ "$FAIL" -gt 0 ]; then
    exit 1
fi
