import javascript

query predicate getRouteHandlerContainerStep(
  HTTP::RouteHandlerCandidateContainer container, DataFlow::SourceNode handler,
  DataFlow::SourceNode access
) {
  handler = container.getRouteHandler(access)
}
