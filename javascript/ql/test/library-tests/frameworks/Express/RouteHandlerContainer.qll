import javascript

query predicate getRouteHandlerContainerStep(
  https::RouteHandlerCandidateContainer container, DataFlow::SourceNode handler,
  DataFlow::SourceNode access
) {
  handler = container.getRouteHandler(access)
}
