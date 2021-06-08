import javascript

query HTTP::RouteHandler routeHandler() { any() }

query HTTP::Servers::RequestSource requestSource() { any() }

query HTTP::Servers::ResponseSource responseSource() { any() }

query HTTP::RequestInputAccess requestInputAccess(string kind) { kind = result.getKind() }

query HTTP::RequestInputAccess userControlledObject() { result.isUserControlledObject() }

query HTTP::ResponseSendArgument responseSendArgument() { any() }

query HTTP::ResponseSendArgument responseSendArgumentHandler(HTTP::RouteHandler h) {
  h = result.getRouteHandler()
}
