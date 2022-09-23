import javascript

query predicate test_RequestExpr(Koa::RequestNode e, Http::RouteHandler res) {
  res = e.getRouteHandler()
}
