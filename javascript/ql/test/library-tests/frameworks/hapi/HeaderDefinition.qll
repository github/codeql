import javascript

query predicate test_HeaderDefinition(https::HeaderDefinition hd, Hapi::RouteHandler rh) {
  rh = hd.getRouteHandler()
}
