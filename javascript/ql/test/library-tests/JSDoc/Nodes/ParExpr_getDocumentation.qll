import javascript

query predicate test_ParExpr_getDocumentation(Expr e, JSDoc res) {
  e.isParenthesized() and res = e.getDocumentation()
}
