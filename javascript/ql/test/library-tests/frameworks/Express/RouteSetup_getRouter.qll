import javascript

query predicate test_RouteSetup_getRouter(Express::RouteSetup rs, Express::RouterDefinition res) {
  res = rs.getRouter()
}
