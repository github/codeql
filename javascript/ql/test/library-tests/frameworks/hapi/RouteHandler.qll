import javascript

query predicate test_RouteHandler(Hapi::RouteHandler rh, DataFlow::Node res) {
  res = rh.getServer()
}
