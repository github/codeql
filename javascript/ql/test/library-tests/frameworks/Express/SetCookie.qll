import javascript

query predicate test_SetCookie(HTTP::CookieDefinition cookiedef, Express::RouteHandler rh) {
  rh = cookiedef.getRouteHandler()
}
