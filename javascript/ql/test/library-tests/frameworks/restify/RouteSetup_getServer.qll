import javascript

query predicate test_RouteSetup_getServer(Restify::RouteSetup rs, DataFlow::Node res) {
  res = rs.getServer()
}
