import semmle.javascript.frameworks.Express

query predicate test_RouteHandler_getAResponseExpr(Restify::RouteHandler rh, Http::ResponseNode res) {
  res = rh.getAResponseNode()
}
