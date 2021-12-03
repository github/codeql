import javascript

query predicate test_RequestInputAccess(
  HTTP::RequestInputAccess ria, string res, Restify::RouteHandler rh
) {
  ria.getRouteHandler() = rh and res = ria.getKind()
}
