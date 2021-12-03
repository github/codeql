import javascript

query predicate test_RequestExpr(Koa::RequestExpr e, HTTP::RouteHandler res) {
  res = e.getRouteHandler()
}
