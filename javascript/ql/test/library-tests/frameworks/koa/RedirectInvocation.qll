import javascript

query predicate test_RedirectInvocation(
  https::RedirectInvocation redirect, Expr url, https::RouteHandler rh
) {
  redirect.getUrlArgument() = url and
  redirect.getRouteHandler() = rh
}
