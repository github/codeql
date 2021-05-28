import javascript

query predicate test_ResponseSendArgument(
  https::ResponseSendArgument send, NodeJSLib::RouteHandler rh
) {
  rh = send.getRouteHandler()
}
