import javascript

query predicate test_HeaderDefinition(HTTP::HeaderDefinition hd, Connect::RouteHandler rh) {
  rh = hd.getRouteHandler()
}
