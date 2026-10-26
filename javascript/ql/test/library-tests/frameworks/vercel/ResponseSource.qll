import javascript

query predicate test_ResponseSource(Http::Servers::ResponseSource src, VercelNode::RouteHandler rh) {
  src.getRouteHandler() = rh
}
