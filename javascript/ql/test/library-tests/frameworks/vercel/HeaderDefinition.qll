import javascript

query predicate test_HeaderDefinition(
  Http::HeaderDefinition hd, string name, VercelNode::RouteHandler rh
) {
  hd.getRouteHandler() = rh and name = hd.getAHeaderName()
}
