import javascript

query predicate test_RedirectInvocation(Http::RedirectInvocation red, Express::RouteHandler rh) {
  rh = red.getRouteHandler()
}
