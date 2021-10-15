import javascript

query predicate test_HeaderDefinition(HTTP::HeaderDefinition hd, Express::RouteHandler rh) {
  rh = hd.getRouteHandler()
}
