#!/bin/bash

CODEQL_PATH="/Users/nicolaswill/.local/share/gh/extensions/gh-codeql/dist/release/v2.20.4/codeql"
DATABASE_PATH="/Users/nicolaswill/pqc/gpt-crypto-test-cases/gpt_ai_gen_jca_test_cases_db"
QUERY_FILE="/Users/nicolaswill/pqc/codeql/java/ql/src/experimental/Quantum/PrintCBOMGraph.ql"
OUTPUT_DIR="graph_output"

python3 generate_cbom.py -c "$CODEQL_PATH" -d "$DATABASE_PATH" -q "$QUERY_FILE" -o "$OUTPUT_DIR"
