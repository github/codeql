import semmle.javascript.frameworks.Express

query predicate test_RouteHandler_getARequestExpr(Connect::RouteHandler rh, HTTP::RequestExpr res) {
  res = rh.getARequestExpr()
}
