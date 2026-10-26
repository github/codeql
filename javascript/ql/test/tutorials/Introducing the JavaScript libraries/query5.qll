import javascript

query predicate test_query5(FunctionExpr fe, string res) {
  fe.getBody() instanceof Expr and res = "Use arrow expressions instead of expression closures."
}
