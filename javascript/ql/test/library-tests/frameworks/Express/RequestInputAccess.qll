import javascript

query predicate test_RequestInputAccess(
  Http::RequestInputAccess ria, string res0, Express::RouteHandler rh
) {
  ria.getRouteHandler() = rh and res0 = ria.getKind()
}
