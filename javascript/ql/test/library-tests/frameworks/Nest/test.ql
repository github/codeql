import javascript
private import semmle.javascript.security.dataflow.ServerSideUrlRedirectCustomizations

query HTTP::RouteHandler routeHandler() { any() }

query HTTP::Servers::RequestSource requestSource() { any() }

query HTTP::Servers::ResponseSource responseSource() { any() }

query RemoteFlowSource requestInputAccess(string kind) {
  kind = result.(HTTP::RequestInputAccess).getKind()
  or
  not result instanceof HTTP::RequestInputAccess and
  kind = "RemoteFlowSource"
}

query HTTP::ResponseSendArgument responseSendArgument() { any() }

query ServerSideUrlRedirect::Sink redirectSink() { any() }
