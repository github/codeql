import javascript

query predicate test_RouteSetup_getServer(Koa::RouteSetup rs, DataFlow::Node res) {
  res = rs.getServer()
}
