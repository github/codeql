import javascript

module TestConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.(DataFlow::InvokeNode).getCalleeName() = "SOURCE"
  }

  predicate isSink(DataFlow::Node sink) {
    exists(DataFlow::InvokeNode call |
      call.getCalleeName() = "SINK" and
      sink = call.getArgument(0)
    )
  }

  predicate isBarrier(DataFlow::Node node) {
    node = DataFlow::MakeBarrierGuard<SimpleBarrierGuardNode>::getABarrierNode()
  }
}

module TestFlow = DataFlow::Global<TestConfig>;

class SimpleBarrierGuardNode extends DataFlow::BarrierGuardNode, DataFlow::InvokeNode {
  SimpleBarrierGuardNode() { this.getCalleeName() = "BARRIER" }

  override predicate blocks(boolean outcome, Expr e) { this.blocksExpr(outcome, e) }

  predicate blocksExpr(boolean outcome, Expr e) {
    outcome = true and
    e = this.getArgument(0).asExpr()
  }
}

deprecated class LegacyConfig extends DataFlow::Configuration {
  LegacyConfig() { this = "LegacyConfig" }

  override predicate isSource(DataFlow::Node source) { TestConfig::isSource(source) }

  override predicate isSink(DataFlow::Node sink) { TestConfig::isSink(sink) }

  override predicate isBarrierGuard(DataFlow::BarrierGuardNode guard) {
    guard instanceof SimpleBarrierGuardNode
  }
}

deprecated import testUtilities.LegacyDataFlowDiff::DataFlowDiff<TestFlow, LegacyConfig>

query predicate flow = TestFlow::flow/2;
