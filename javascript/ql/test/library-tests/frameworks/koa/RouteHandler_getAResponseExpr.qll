import semmle.javascript.frameworks.Express

query predicate test_RouteHandler_getAResponseExpr(Koa::RouteHandler rh, HTTP::ResponseExpr res) {
  res = rh.getAResponseExpr()
}
