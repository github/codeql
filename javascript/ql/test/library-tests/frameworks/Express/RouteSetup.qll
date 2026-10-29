import javascript

query predicate test_RouteSetup(Express::RouteSetup rs, DataFlow::Node res0, boolean isUseCall) {
  (if rs.isUseCall() then isUseCall = true else isUseCall = false) and
  res0 = rs.getServer()
}
