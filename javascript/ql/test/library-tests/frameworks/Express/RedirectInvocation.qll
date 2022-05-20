import javascript

query predicate test_RedirectInvocation(HTTP::RedirectInvocation red, Express::RouteHandler rh) {
  rh = red.getRouteHandler()
}
