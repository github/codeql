import javascript

query predicate test_ResponseSendArgument(
  HTTP::ResponseSendArgument send, NodeJSLib::RouteHandler rh
) {
  rh = send.getRouteHandler()
}
