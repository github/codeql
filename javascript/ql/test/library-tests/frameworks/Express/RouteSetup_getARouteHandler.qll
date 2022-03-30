import javascript

query predicate test_RouteSetup_getARouteHandler(Express::RouteSetup r, DataFlow::SourceNode res) {
  res = r.getARouteHandler()
}
