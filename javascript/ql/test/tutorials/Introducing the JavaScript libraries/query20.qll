import javascript

query predicate test_query20(SQL::SqlString ss, string res) {
  ss instanceof AddExpr and res = "Use templating instead of string concatenation."
}
