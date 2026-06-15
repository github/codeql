import javascript

query predicate test_RequestInputAccess(
  Http::RequestInputAccess ria, string kind, VercelNode::RouteHandler rh
) {
  ria.getRouteHandler() = rh and kind = ria.getKind()
}
