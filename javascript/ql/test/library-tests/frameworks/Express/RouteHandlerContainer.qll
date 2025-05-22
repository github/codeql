import javascript

query DataFlow::SourceNode getRouteHandlerContainerStep(
  Http::RouteHandlerCandidateContainer container, DataFlow::SourceNode handler
) {
  handler = container.getRouteHandler(result)
}
