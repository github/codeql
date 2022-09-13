import javascript

query predicate test_ResponseExpr(Koa::ResponseNode e, HTTP::RouteHandler res) {
  res = e.getRouteHandler()
}
