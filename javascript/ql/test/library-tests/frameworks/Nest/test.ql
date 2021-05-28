import javascript
private import semmle.javascript.security.dataflow.ServerSideUrlRedirectCustomizations

query https::RouteHandler routeHandler() { any() }

query https::Servers::RequestSource requestSource() { any() }

query https::Servers::ResponseSource responseSource() { any() }

query RemoteFlowSource requestInputAccess(string kind) {
  kind = result.(https::RequestInputAccess).getKind()
  or
  not result instanceof https::RequestInputAccess and
  kind = "RemoteFlowSource"
}

query https::ResponseSendArgument responseSendArgument() { any() }

query ServerSideUrlRedirect::Sink redirectSink() { any() }
