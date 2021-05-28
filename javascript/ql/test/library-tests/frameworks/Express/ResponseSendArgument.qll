import javascript

query predicate test_ResponseSendArgument(https::ResponseSendArgument send, Express::RouteHandler rh) {
  rh = send.getRouteHandler()
}
