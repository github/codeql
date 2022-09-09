import javascript

query predicate test_HeaderDefinition(Http::HeaderDefinition hd, Hapi::RouteHandler rh) {
  rh = hd.getRouteHandler()
}
