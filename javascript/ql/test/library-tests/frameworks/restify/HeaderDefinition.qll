import javascript

query predicate test_HeaderDefinition(Http::HeaderDefinition hd, Restify::RouteHandler rh) {
  rh = hd.getRouteHandler()
}
