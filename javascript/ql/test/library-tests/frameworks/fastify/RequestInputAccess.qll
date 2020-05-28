import javascript

query predicate test_RequestInputAccess(
  HTTP::RequestInputAccess ria, string res, Fastify::RouteHandler rh, boolean isUserControlledObject
) {
  ria.getRouteHandler() = rh and
  res = ria.getKind() and
  if ria.isUserControlledObject()
  then isUserControlledObject = true
  else isUserControlledObject = false
}
