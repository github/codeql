import javascript

query predicate test_RouteSetup_getServer(Fastify::RouteSetup rs, DataFlow::Node res) {
  res = rs.getServer()
}
