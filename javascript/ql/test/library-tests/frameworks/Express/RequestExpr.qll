import javascript

query predicate test_RequestExpr(Express::RequestNode e, Http::RouteHandler res) {
  res = e.getRouteHandler()
}

query predicate test_RequestExprStandalone(Express::RequestNode e) {
  not exists(e.getRouteHandler())
}
