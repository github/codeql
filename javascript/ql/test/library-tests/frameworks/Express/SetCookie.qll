import javascript

query predicate test_SetCookie(https::CookieDefinition cookiedef, Express::RouteHandler rh) {
  rh = cookiedef.getRouteHandler()
}
