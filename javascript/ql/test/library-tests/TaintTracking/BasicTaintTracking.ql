import javascript

DataFlow::CallNode getACall(string name) { result.getCalleeName() = name }

class BasicConfig extends TaintTracking::Configuration {
  BasicConfig() { this = "BasicConfig" }

  override predicate isSource(DataFlow::Node node) { node = getACall("source") }

  override predicate isSink(DataFlow::Node node) { node = getACall("sink").getAnArgument() }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode node) {
    node instanceof BasicSanitizerGuard
  }
}

class BasicSanitizerGuard extends TaintTracking::SanitizerGuardNode, DataFlow::CallNode {
  BasicSanitizerGuard() { this = getACall("isSafe") }

  override predicate sanitizes(boolean outcome, Expr e) {
    outcome = true and e = getArgument(0).asExpr()
  }
}

from BasicConfig cfg, DataFlow::Node src, DataFlow::Node sink
where cfg.hasFlow(src, sink)
select src, sink
