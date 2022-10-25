import javascript

query predicate test_ResponseSendArgument(Http::ResponseSendArgument arg, Fastify::RouteHandler rh) {
  arg.getRouteHandler() = rh
}
