import javascript

query predicate test_RouteSetup_getRequestMethod(Express::RouteSetup rs, Http::RequestMethodName res) {
  res = rs.getRequestMethod()
}
