import javascript

query predicate test_RedirectInvocation(https::RedirectInvocation invk, Fastify::RouteHandler rh) {
  invk.getRouteHandler() = rh
}
