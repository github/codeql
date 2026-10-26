import javascript

query predicate test_ResponseSendArgument(Http::ResponseSendArgument send, Koa::RouteHandler rh) {
  rh = send.getRouteHandler()
}
