import javascript

query predicate test_HeaderDefinition(HTTP::HeaderDefinition hd, Hapi::RouteHandler rh) {
  rh = hd.getRouteHandler()
}
