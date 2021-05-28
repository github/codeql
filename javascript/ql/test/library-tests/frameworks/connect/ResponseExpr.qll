import javascript

query predicate test_ResponseExpr(Connect::ResponseExpr e, https::RouteHandler res) {
  res = e.getRouteHandler()
}
