import javascript

query predicate test_RouteSetup_getARouteHandler(NodeJSLib::RouteSetup r, DataFlow::SourceNode res) {
  res = r.getARouteHandler()
}
