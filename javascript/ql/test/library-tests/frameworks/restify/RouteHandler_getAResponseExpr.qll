import semmle.javascript.frameworks.Express

query predicate test_RouteHandler_getAResponseExpr(Restify::RouteHandler rh, HTTP::ResponseNode res) {
  res = rh.getAResponseNode()
}
