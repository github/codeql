import javascript

query predicate test_ResponseExpr(Koa::ResponseExpr e, HTTP::RouteHandler res) {
  res = e.getRouteHandler()
}
