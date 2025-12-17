#!/bin/bash
set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
QL_LIB="$PROJECT_ROOT/ql/lib"

echo "=== PHP CodeQL Package Generation ==="
echo ""

# Step 1: Build Rust extractor
echo "Step 1: Building Rust extractor..."
cd "$PROJECT_ROOT/extractor"
cargo build --release
echo "✓ Build complete"
echo ""

# Step 2: Generate dbscheme (existing command)
echo "Step 2: Generating dbscheme..."
./target/release/codeql-extractor-php generate \
    --dbscheme "$QL_LIB/php.dbscheme" \
    --library "$QL_LIB/codeql/php/ast/internal/TreeSitter.qll"
echo "✓ Database schema generated"
echo ""

# Step 3: Generate stats file (NEW separate command)
echo "Step 3: Generating statistics file..."
bash "$SCRIPT_DIR/generate-stats.sh" basic
echo ""

# Step 4: Verify stats file
echo "Step 4: Verifying stats file..."
if [ -f "$QL_LIB/php.dbscheme.stats" ]; then
    echo "✓ Stats file verified: $QL_LIB/php.dbscheme.stats"
else
    echo "✗ ERROR: Stats file not found"
    exit 1
fi
echo ""

echo "=== Package Generation Complete ==="
echo ""
echo "Next steps:"
echo "1. Review the generated files:"
echo "   - $QL_LIB/php.dbscheme"
echo "   - $QL_LIB/php.dbscheme.stats"
echo "   - $QL_LIB/codeql/php/ast/internal/TreeSitter.qll"
echo ""
echo "2. Commit php.dbscheme.stats to repository:"
echo "   git add $QL_LIB/php.dbscheme.stats"
echo "   git commit -m 'Add pre-generated php.dbscheme.stats'"
echo ""
echo "3. Create a CodeQL database:"
echo "   codeql database create db --language=php --source-root=."
echo ""
echo "4. Finalize the database:"
echo "   python3 php-codeql-finalizer.py db"
echo ""
echo "5. Run security queries:"
echo "   codeql query run --database=db queries/security/"
echo ""
