import javascript

query predicate test_ResponseSendArgument(HTTP::ResponseSendArgument send, Koa::RouteHandler rh) {
  rh = send.getRouteHandler()
}
