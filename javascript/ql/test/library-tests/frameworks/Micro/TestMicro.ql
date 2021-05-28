import javascript

query https::RouteHandler routeHandler() { any() }

query https::Servers::RequestSource requestSource() { any() }

query https::Servers::ResponseSource responseSource() { any() }

query https::RequestInputAccess requestInputAccess(string kind) { kind = result.getKind() }

query https::RequestInputAccess userControlledObject() { result.isUserControlledObject() }

query https::ResponseSendArgument responseSendArgument() { any() }

query https::ResponseSendArgument responseSendArgumentHandler(https::RouteHandler h) {
  h = result.getRouteHandler()
}
