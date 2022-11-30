import javascript

query predicate test_RouteHandler(Restify::RouteHandler rh, DataFlow::Node res) {
  res = rh.getServer()
}
