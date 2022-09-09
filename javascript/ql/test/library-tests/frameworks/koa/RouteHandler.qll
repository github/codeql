import javascript

query predicate test_RouteHandler(Koa::RouteHandler rh, DataFlow::Node res) { res = rh.getServer() }
