import javascript

query predicate test_RequestExpr(Koa::RequestNode e, HTTP::RouteHandler res) {
  res = e.getRouteHandler()
}
