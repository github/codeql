import javascript

query predicate test_HeaderDefinition(https::HeaderDefinition hd, Express::RouteHandler rh) {
  rh = hd.getRouteHandler()
}
