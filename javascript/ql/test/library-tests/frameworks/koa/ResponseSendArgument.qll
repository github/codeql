import javascript

query predicate test_ResponseSendArgument(https::ResponseSendArgument send, Koa::RouteHandler rh) {
  rh = send.getRouteHandler()
}
