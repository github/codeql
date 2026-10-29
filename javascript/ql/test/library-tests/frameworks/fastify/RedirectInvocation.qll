import javascript

query predicate test_RedirectInvocation(Http::RedirectInvocation invk, Fastify::RouteHandler rh) {
  invk.getRouteHandler() = rh
}
