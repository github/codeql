import javascript

query predicate test_ResponseExpr(HTTP::ResponseExpr e, HTTP::RouteHandler res) {
  res = e.getRouteHandler()
}
