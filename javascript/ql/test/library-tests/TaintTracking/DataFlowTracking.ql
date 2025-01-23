import javascript

DataFlow::CallNode getACall(string name) { result.getCalleeName() = name }

module TestConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node = getACall("source") }

  predicate isSink(DataFlow::Node node) { node = getACall("sink").getAnArgument() }

  predicate isBarrier(DataFlow::Node node) {
    node = DataFlow::MakeBarrierGuard<BasicBarrierGuard>::getABarrierNode()
  }
}

module TestFlow = DataFlow::Global<TestConfig>;

class BasicBarrierGuard extends DataFlow::CallNode {
  BasicBarrierGuard() { this = getACall("isSafe") }

  predicate blocksExpr(boolean outcome, Expr e) {
    outcome = true and e = this.getArgument(0).asExpr()
  }
}

deprecated class BasicBarrierGuardLegacy extends DataFlow::BarrierGuardNode instanceof BasicBarrierGuard
{
  override predicate blocks(boolean outcome, Expr e) { super.blocksExpr(outcome, e) }
}

deprecated class LegacyConfig extends DataFlow::Configuration {
  LegacyConfig() { this = "LegacyConfig" }

  override predicate isSource(DataFlow::Node source) { TestConfig::isSource(source) }

  override predicate isSink(DataFlow::Node sink) { TestConfig::isSink(sink) }

  override predicate isBarrierGuard(DataFlow::BarrierGuardNode node) {
    node instanceof BasicBarrierGuardLegacy
  }
}

deprecated import utils.test.LegacyDataFlowDiff::DataFlowDiff<TestFlow, LegacyConfig>

query predicate flow = TestFlow::flow/2;
