import javascript

query predicate test_RouteSetup_getServer(Hapi::RouteSetup rs, DataFlow::Node res) {
  res = rs.getServer()
}
