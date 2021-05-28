import javascript

query predicate test_HeaderDefinition(https::HeaderDefinition hd, Connect::RouteHandler rh) {
  rh = hd.getRouteHandler()
}
