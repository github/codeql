import javascript

query predicate test_RequestExpr(Express::RequestExpr e, https::RouteHandler res) {
  res = e.getRouteHandler()
}

query predicate test_RequestExprStandalone(Express::RequestExpr e) {
  not exists(e.getRouteHandler())
}
