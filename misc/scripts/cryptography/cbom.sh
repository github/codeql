#!/bin/bash

CODEQL_PATH="/Users/nicolaswill/Library/Application Support/Code/User/globalStorage/github.vscode-codeql/distribution5/codeql/codeql"
DATABASE_PATH="/Users/nicolaswill/openssl_codeql/openssl/openssl_db"
QUERY_FILE="/Users/nicolaswill/pqc/codeql/cpp/ql/src/experimental/Quantum/CBOMGraph.ql"
OUTPUT_DIR="graph_output"

python3 generate_cbom.py -c "$CODEQL_PATH" -d "$DATABASE_PATH" -q "$QUERY_FILE" -o "$OUTPUT_DIR"
