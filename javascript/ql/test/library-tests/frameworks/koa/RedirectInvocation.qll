import javascript

query predicate test_RedirectInvocation(
  Http::RedirectInvocation redirect, DataFlow::Node url, Http::RouteHandler rh
) {
  redirect.getUrlArgument() = url and
  redirect.getRouteHandler() = rh
}
