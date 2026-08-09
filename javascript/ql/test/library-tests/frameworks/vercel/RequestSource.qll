import javascript

query predicate test_RequestSource(Http::Servers::RequestSource src, VercelNode::RouteHandler rh) {
  src.getRouteHandler() = rh
}
