import javascript

query predicate test_RouteSetup_getServer(Express::RouteSetup rs, DataFlow::Node res) {
  res = rs.getServer()
}
