import javascript

query predicate test_RedirectInvocation(HTTP::RedirectInvocation invk, Fastify::RouteHandler rh) {
  invk.getRouteHandler() = rh
}
