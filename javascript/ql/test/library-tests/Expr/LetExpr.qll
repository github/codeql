import javascript

query predicate test_LetExpr(LegacyLetExpr l, int i, VariableDeclarator res0, Expr res1) {
  res0 = l.getDecl(i) and res1 = l.getBody()
}
