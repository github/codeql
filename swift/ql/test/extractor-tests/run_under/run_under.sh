ARGS=$(echo $@ | sed 's='$CODEQL_EXTRACTOR_SWIFT_ROOT'=$CODEQL_EXTRACTOR_SWIFT_ROOT=g; s/'$CODEQL_PLATFORM'/$CODEQL_PLATFORM/g')

cat > $CODEQL_EXTRACTOR_SWIFT_TRAP_DIR/$$.trap << EOF
string_literal_exprs(*, "run_under: $ARGS")
EOF

"$@"
