import javascript

query predicate test_HeaderDefinition(Http::HeaderDefinition hd, Koa::RouteHandler rh) {
  rh = hd.getRouteHandler()
}
