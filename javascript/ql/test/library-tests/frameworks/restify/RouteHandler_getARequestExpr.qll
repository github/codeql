import semmle.javascript.frameworks.Express

query predicate test_RouteHandler_getARequestExpr(Restify::RouteHandler rh, HTTP::RequestNode res) {
  res = rh.getARequestNode()
}
