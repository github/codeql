import javascript

query predicate test_HeaderDefinition(HTTP::HeaderDefinition hd, Fastify::RouteHandler rh) {
  rh = hd.getRouteHandler()
}
