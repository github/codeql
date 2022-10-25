import javascript
private import semmle.javascript.security.dataflow.ServerSideUrlRedirectCustomizations

query Http::RouteHandler routeHandler() { any() }

query Http::Servers::RequestSource requestSource() { any() }

query Http::Servers::ResponseSource responseSource() { any() }

query RemoteFlowSource requestInputAccess(string kind) {
  kind = result.(Http::RequestInputAccess).getKind()
  or
  not result instanceof Http::RequestInputAccess and
  kind = "RemoteFlowSource"
}

query Http::ResponseSendArgument responseSendArgument() { any() }

query ServerSideUrlRedirect::Sink redirectSink() { any() }
