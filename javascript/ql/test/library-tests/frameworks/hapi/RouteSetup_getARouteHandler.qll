import javascript

query predicate test_RouteSetup_getARouteHandler(Hapi::RouteSetup r, DataFlow::SourceNode res) {
  res = r.getARouteHandler()
}
