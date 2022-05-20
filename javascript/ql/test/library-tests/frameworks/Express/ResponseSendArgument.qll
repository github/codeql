import javascript

query predicate test_ResponseSendArgument(HTTP::ResponseSendArgument send, Express::RouteHandler rh) {
  rh = send.getRouteHandler()
}
