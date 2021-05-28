import javascript

query predicate test_RouteSetup_getRequestMethod(Express::RouteSetup rs, https::RequestMethodName res) {
  res = rs.getRequestMethod()
}
