import javascript

query Http::RouteHandler routeHandler() { any() }

query Http::Servers::RequestSource requestSource() { any() }

query Http::Servers::ResponseSource responseSource() { any() }

query Http::RequestInputAccess requestInputAccess(string kind) { kind = result.getKind() }

query Http::RequestInputAccess userControlledObject() { result.isUserControlledObject() }

query Http::ResponseSendArgument responseSendArgument() { any() }

query Http::ResponseSendArgument responseSendArgumentHandler(Http::RouteHandler h) {
  h = result.getRouteHandler()
}
