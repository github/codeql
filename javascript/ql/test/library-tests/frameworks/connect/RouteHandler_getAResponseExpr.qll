import semmle.javascript.frameworks.Express

query predicate test_RouteHandler_getAResponseExpr(Connect::RouteHandler rh, https::ResponseExpr res) {
  res = rh.getAResponseExpr()
}
