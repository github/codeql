import javascript

query predicate test_RedirectInvocation(
  HTTP::RedirectInvocation redirect, Expr url, HTTP::RouteHandler rh
) {
  redirect.getUrlArgument() = url and
  redirect.getRouteHandler() = rh
}
