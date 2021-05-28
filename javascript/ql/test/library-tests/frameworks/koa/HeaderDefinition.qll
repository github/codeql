import javascript

query predicate test_HeaderDefinition(https::HeaderDefinition hd, Koa::RouteHandler rh) {
  rh = hd.getRouteHandler()
}
