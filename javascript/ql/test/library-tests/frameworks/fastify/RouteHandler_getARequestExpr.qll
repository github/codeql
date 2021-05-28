import semmle.javascript.frameworks.Express

query predicate test_RouteHandler_getARequestExpr(Fastify::RouteHandler rh, https::RequestExpr res) {
  res = rh.getARequestExpr()
}
