import javascript

query predicate test_query9(FunctionDeclStmt f, FunctionDeclStmt g) {
  f != g and
  f.getVariable() = g.getVariable() and
  not f.getTopLevel().isMinified() and
  not g.getTopLevel().isMinified()
}
