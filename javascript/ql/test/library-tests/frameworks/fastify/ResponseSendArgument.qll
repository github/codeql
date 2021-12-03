import javascript

query predicate test_ResponseSendArgument(HTTP::ResponseSendArgument arg, Fastify::RouteHandler rh) {
  arg.getRouteHandler() = rh
}
