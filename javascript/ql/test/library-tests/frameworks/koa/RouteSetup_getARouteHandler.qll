import javascript

query predicate test_RouteSetup_getARouteHandler(Koa::RouteSetup r, DataFlow::SourceNode res) {
  res = r.getARouteHandler()
}
