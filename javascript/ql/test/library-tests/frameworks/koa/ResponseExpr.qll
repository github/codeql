import javascript

query predicate test_ResponseExpr(Koa::ResponseNode e, Http::RouteHandler res) {
  res = e.getRouteHandler()
}
