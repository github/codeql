import javascript

query predicate test_ResponseSendArgument(
  Http::ResponseSendArgument send, NodeJSLib::RouteHandler rh
) {
  rh = send.getRouteHandler()
}
