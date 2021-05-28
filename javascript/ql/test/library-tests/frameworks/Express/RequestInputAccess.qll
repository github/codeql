import javascript

query predicate test_RequestInputAccess(
  https::RequestInputAccess ria, string res0, Express::RouteHandler rh
) {
  ria.getRouteHandler() = rh and res0 = ria.getKind()
}
