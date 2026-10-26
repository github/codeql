import semmle.javascript.frameworks.Express

query predicate test_RouteHandler_getARequestExpr(Koa::RouteHandler rh, Http::RequestNode res) {
  res = rh.getARequestNode()
}
