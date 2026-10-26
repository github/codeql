import javascript

query predicate test_ResponseSendArgument(
  Http::ResponseSendArgument arg, VercelNode::RouteHandler rh
) {
  arg.getRouteHandler() = rh
}
