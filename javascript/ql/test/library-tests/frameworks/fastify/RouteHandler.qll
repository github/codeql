import javascript

query predicate test_RouteHandler(Fastify::RouteHandler rh, Expr res) { res = rh.getServer() }
