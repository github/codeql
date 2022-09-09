import javascript

query predicate getRouteHandlerContainerStep(
  Http::RouteHandlerCandidateContainer container, DataFlow::SourceNode handler,
  DataFlow::SourceNode access
) {
  handler = container.getRouteHandler(access)
}
