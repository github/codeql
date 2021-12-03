import semmle.javascript.frameworks.Express

query predicate test_RouteHandler_getAContextExpr(Koa::RouteHandler rh, Expr res) {
  res = rh.getAContextExpr()
}
