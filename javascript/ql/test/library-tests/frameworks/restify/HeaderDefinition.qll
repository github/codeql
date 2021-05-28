import javascript

query predicate test_HeaderDefinition(https::HeaderDefinition hd, Restify::RouteHandler rh) {
  rh = hd.getRouteHandler()
}
