import javascript

query predicate test_HeaderDefinition(HTTP::HeaderDefinition hd, Koa::RouteHandler rh) {
  rh = hd.getRouteHandler()
}
