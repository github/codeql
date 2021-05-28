import javascript

query predicate test_ResponseSendArgument(https::ResponseSendArgument arg, Fastify::RouteHandler rh) {
  arg.getRouteHandler() = rh
}
