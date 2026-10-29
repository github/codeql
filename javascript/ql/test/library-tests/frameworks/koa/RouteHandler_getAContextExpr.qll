import semmle.javascript.frameworks.Express

query predicate test_RouteHandler_getAContextExpr(Koa::RouteHandler rh, DataFlow::Node res) {
  res = rh.getAContextNode()
}
