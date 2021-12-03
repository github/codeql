import javascript

query predicate test_RouteSetup_getARouteHandler(Fastify::RouteSetup r, DataFlow::SourceNode res) {
  res = r.getARouteHandler()
}
