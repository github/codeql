import semmle.javascript.frameworks.Express

query predicate test_RouteHandler_getARequestExpr(Express::RouteHandler rh, HTTP::RequestExpr res) {
  res = rh.getARequestExpr()
}
