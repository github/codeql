import javascript

query predicate test_RouteHandler_getARequestBodyAccess(Express::RouteHandler rh, Expr res) {
  res = rh.getARequestBodyAccess()
}
