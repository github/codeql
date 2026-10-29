import javascript

query predicate test_RouteHandler(Fastify::RouteHandler rh, DataFlow::Node res) {
  res = rh.getServer()
}
