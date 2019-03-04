import javascript

query predicate test_RequestExpr(Express::RequestExpr e, HTTP::RouteHandler res) {
  res = e.getRouteHandler()
}
