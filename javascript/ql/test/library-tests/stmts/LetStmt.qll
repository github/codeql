import javascript

query predicate test_LetStmt(LegacyLetStmt l, int i, VariableDeclarator res0, Stmt res1) {
  res0 = l.getDecl(i) and res1 = l.getBody()
}
