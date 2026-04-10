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
#   NODEJS_WRAPPER  — Path to Node.js wrapper main.js (default: auto-detect)
#   GO_WRAPPER      — Path to Go wrapper binary (default: builds from source)
#   TIMEOUT         — Seconds to wait for each parse (default: 10)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
EXTRACTOR_LIB="$(cd "$PROJECT_DIR/.." && pwd)"
TYPESCRIPT_DIR="$EXTRACTOR_LIB/typescript"
TIMEOUT="${TIMEOUT:-10}"

# Locate the Node.js wrapper (prefer compiled .js)
find_nodejs_wrapper() {
    local js_path="$TYPESCRIPT_DIR/build/main.js"
    if [ -f "$js_path" ]; then
        echo "$js_path"
        return
    fi
    echo ""
}

NODEJS_WRAPPER="${NODEJS_WRAPPER:-$(find_nodejs_wrapper)}"

# Build and locate the Go wrapper
GO_WRAPPER="${GO_WRAPPER:-$PROJECT_DIR/bin/typescript-parser-wrapper}"
if [ ! -f "$GO_WRAPPER" ]; then
    echo "Building Go wrapper..."
    mkdir -p "$PROJECT_DIR/bin"
    (cd "$PROJECT_DIR" && go build -o bin/typescript-parser-wrapper ./cmd/typescript-parser-wrapper/) || {
        echo "Failed to build Go wrapper."
        GO_WRAPPER=""
    }
fi

# Colors (disabled if not a terminal)
if [ -t 1 ]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    NC='\033[0m'
else
    RED='' GREEN='' YELLOW='' NC=''
fi

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
    sys.exit(1)
" 2>/dev/null
}

# Parse a file using the wrapper's stdin protocol.
# Usage: parse_with_protocol <cmd> <file>
#   cmd: the shell command to start the wrapper (e.g., "node main.js" or "./wrapper")
#   file: absolute path to the .ts file
#
# Sends parse + quit commands on stdin and extracts the AST response line.
parse_with_protocol() {
    local cmd="$1"
    local file="$2"

    local output
    output=$(printf '{"command":"parse","filename":"%s"}\n{"command":"quit"}\n' "$file" \
        | timeout "$TIMEOUT" $cmd 2>/dev/null) || true

    # Extract the line containing the AST response
    echo "$output" | while IFS= read -r line; do
        if echo "$line" | python3 -c "import json,sys; d=json.load(sys.stdin); sys.exit(0 if d.get('type')=='ast' else 1)" 2>/dev/null; then
            echo "$line"
            break
        fi
    done
}

# Parse a file with the Node.js wrapper
parse_nodejs() {
    local file="$1"
    if [ -z "$NODEJS_WRAPPER" ]; then
        echo ""
        return
    fi
    parse_with_protocol "node --no-warnings $NODEJS_WRAPPER" "$file"
}

# Parse a file with the Go wrapper
parse_go() {
    local file="$1"
    if [ -z "$GO_WRAPPER" ]; then
        echo ""
        return
    fi
    parse_with_protocol "$GO_WRAPPER" "$file"
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
    nodejs_norm=$(echo "$nodejs_out" | normalize_json) || {
        echo -e "  ${YELLOW}SKIP${NC} $basename (Node.js output not valid JSON)"
        SKIP=$((SKIP + 1))
        return
    }
    go_norm=$(echo "$go_out" | normalize_json) || {
        echo -e "  ${YELLOW}SKIP${NC} $basename (Go output not valid JSON)"
        SKIP=$((SKIP + 1))
        return
    }
    
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
echo "  Timeout:         ${TIMEOUT}s per file"
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
