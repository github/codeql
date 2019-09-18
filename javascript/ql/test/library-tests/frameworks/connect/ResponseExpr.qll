import javascript

query predicate test_ResponseExpr(Connect::ResponseExpr e, HTTP::RouteHandler res) {
  res = e.getRouteHandler()
}
