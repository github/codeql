import javascript
private import semmle.javascript.security.dataflow.ServerSideUrlRedirectCustomizations
private import utils.test.InlineFlowTest

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

module TestConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node node) {
    exists(DataFlow::CallNode call | call.getCalleeName() = "sink" and node = call.getArgument(0))
  }
}

import ValueFlowTest<TestConfig>
