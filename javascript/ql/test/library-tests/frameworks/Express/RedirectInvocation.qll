import javascript

query predicate test_RedirectInvocation(https::RedirectInvocation red, Express::RouteHandler rh) {
  rh = red.getRouteHandler()
}
