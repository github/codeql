import javascript
import semmle.javascript.security.dataflow.RemoteFlowSources

class ExampleConfiguration extends TaintTracking::Configuration {
  ExampleConfiguration() { this = "ExampleConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr().(CallExpr).getCalleeName() = "SOURCE"
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(CallExpr callExpr |
      callExpr.getCalleeName() = "SINK" and
      DataFlow::valueNode(callExpr.getArgument(0)) = sink
    )
  }

  override predicate isSanitizer(DataFlow::Node node) {
    exists(CallExpr callExpr |
      callExpr.getCalleeName() = "SANITIZE" and
      DataFlow::valueNode(callExpr.getArgument(0)) = node
    )
  }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
    // add additional generic sanitizers
    guard instanceof TaintTracking::AdHocWhitelistCheckSanitizer
  }
}
