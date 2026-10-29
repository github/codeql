import javascript

query predicate test_RedirectInvocation(
  Http::RedirectInvocation call, DataFlow::Node url, VercelNode::RouteHandler rh
) {
  call.getRouteHandler() = rh and url = call.getUrlArgument()
}
