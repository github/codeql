import javascript

query predicate test_RouteSetup_handlesAllRequestMethods(Express::RouteSetup rs) {
  rs.handlesAllRequestMethods()
}
