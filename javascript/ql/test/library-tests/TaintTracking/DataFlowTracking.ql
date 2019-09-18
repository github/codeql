import javascript

DataFlow::CallNode getACall(string name) { result.getCalleeName() = name }

class BasicConfig extends DataFlow::Configuration {
  BasicConfig() { this = "BasicConfig" }

  override predicate isSource(DataFlow::Node node) { node = getACall("source") }

  override predicate isSink(DataFlow::Node node) { node = getACall("sink").getAnArgument() }

  override predicate isBarrierGuard(DataFlow::BarrierGuardNode node) {
    node instanceof BasicBarrierGuard
  }
}

class BasicBarrierGuard extends DataFlow::BarrierGuardNode, DataFlow::CallNode {
  BasicBarrierGuard() { this = getACall("isSafe") }

  override predicate blocks(boolean outcome, Expr e) {
    outcome = true and e = getArgument(0).asExpr()
  }
}

from BasicConfig cfg, DataFlow::Node src, DataFlow::Node sink
where cfg.hasFlow(src, sink)
select src, sink
