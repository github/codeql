import javascript

class Configuration extends DataFlow::Configuration {
  Configuration() { this = "SimpleBarrierGuard" }

  override predicate isSource(DataFlow::Node source) {
    source.(DataFlow::InvokeNode).getCalleeName() = "SOURCE"
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(DataFlow::InvokeNode call |
      call.getCalleeName() = "SINK" and
      sink = call.getArgument(0)
    )
  }

  override predicate isBarrierGuard(DataFlow::BarrierGuardNode guard) {
    guard instanceof SimpleBarrierGuardNode
  }
}

class SimpleBarrierGuardNode extends DataFlow::BarrierGuardNode, DataFlow::InvokeNode {
  SimpleBarrierGuardNode() { getCalleeName() = "BARRIER" }

  override predicate blocks(boolean outcome, Expr e) {
    outcome = true and
    e = getArgument(0).asExpr()
  }
}

from Configuration cfg, DataFlow::Node source, DataFlow::Node sink
where cfg.hasFlow(source, sink)
select sink, source
