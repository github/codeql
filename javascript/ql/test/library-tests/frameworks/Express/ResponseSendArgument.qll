import javascript

query predicate test_ResponseSendArgument(Http::ResponseSendArgument send, Express::RouteHandler rh) {
  rh = send.getRouteHandler()
}
