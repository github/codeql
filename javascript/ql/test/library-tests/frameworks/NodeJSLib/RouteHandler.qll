import javascript

query predicate test_RouteHandler(NodeJSLib::RouteHandler rh, DataFlow::Node res) {
  res = rh.getServer()
}
