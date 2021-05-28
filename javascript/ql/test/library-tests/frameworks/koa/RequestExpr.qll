import javascript

query predicate test_RequestExpr(Koa::RequestExpr e, https::RouteHandler res) {
  res = e.getRouteHandler()
}
