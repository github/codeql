import javascript

query predicate test_RouteSetup_getRequestMethod(Express::RouteSetup rs, HTTP::RequestMethodName res) {
  res = rs.getRequestMethod()
}
