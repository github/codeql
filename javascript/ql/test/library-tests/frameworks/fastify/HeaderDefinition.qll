import javascript

query predicate test_HeaderDefinition(Http::HeaderDefinition hd, Fastify::RouteHandler rh) {
  rh = hd.getRouteHandler()
}
