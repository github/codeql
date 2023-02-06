import javascript

query predicate test_HeaderDefinition(Http::HeaderDefinition hd, Express::RouteHandler rh) {
  rh = hd.getRouteHandler()
}
