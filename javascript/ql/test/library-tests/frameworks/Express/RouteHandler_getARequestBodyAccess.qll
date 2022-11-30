import javascript

query predicate test_RouteHandler_getARequestBodyAccess(Express::RouteHandler rh, DataFlow::Node res) {
  res = rh.getARequestBodyAccess()
}
