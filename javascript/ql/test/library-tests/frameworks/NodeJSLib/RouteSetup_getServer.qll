import javascript

query predicate test_RouteSetup_getServer(NodeJSLib::RouteSetup r, DataFlow::Node res) {
  res = r.getServer()
}
