import semmle.javascript.frameworks.Express

query predicate test_RouteHandler_getAResponseExpr(Koa::RouteHandler rh, HTTP::ResponseNode res) {
  res = rh.getAResponseNode()
}
