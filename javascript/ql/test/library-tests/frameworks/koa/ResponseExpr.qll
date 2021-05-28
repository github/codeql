import javascript

query predicate test_ResponseExpr(Koa::ResponseExpr e, https::RouteHandler res) {
  res = e.getRouteHandler()
}
