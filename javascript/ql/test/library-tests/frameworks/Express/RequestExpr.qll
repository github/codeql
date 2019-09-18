import javascript

query predicate test_RequestExpr(Express::RequestExpr e, HTTP::RouteHandler res) {
  res = e.getRouteHandler()
}

query predicate test_RequestExprStandalone(Express::RequestExpr e) {
  not exists(e.getRouteHandler())
}
