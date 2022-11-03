import javascript

query predicate test_HeaderDefinition(HTTP::HeaderDefinition hd, Restify::RouteHandler rh) {
  rh = hd.getRouteHandler()
}
