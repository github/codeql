import javascript

query predicate test_SetCookie(Http::CookieDefinition cookiedef, Express::RouteHandler rh) {
  rh = cookiedef.getRouteHandler()
}
