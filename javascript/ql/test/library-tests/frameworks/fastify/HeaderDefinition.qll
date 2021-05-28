import javascript

query predicate test_HeaderDefinition(https::HeaderDefinition hd, Fastify::RouteHandler rh) {
  rh = hd.getRouteHandler()
}
