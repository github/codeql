import javascript

DataFlow::CallNode getACall(string name) { result.getCalleeName() = name }

module TestConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node = getACall("source") }

  predicate isSink(DataFlow::Node node) { node = getACall("sink").getAnArgument() }

  additional predicate isBarrierGuard(DataFlow::BarrierGuardNode node) {
    node instanceof BasicBarrierGuard
  }

  predicate isBarrier(DataFlow::Node node) {
    node = DataFlow::MakeLegacyBarrierGuard<isBarrierGuard/1>::getABarrierNode()
  }
}

module TestFlow = DataFlow::Global<TestConfig>;

class BasicBarrierGuard extends DataFlow::BarrierGuardNode, DataFlow::CallNode {
  BasicBarrierGuard() { this = getACall("isSafe") }

  override predicate blocks(boolean outcome, Expr e) { this.blocksExpr(outcome, e) }

  predicate blocksExpr(boolean outcome, Expr e) {
    outcome = true and e = this.getArgument(0).asExpr()
  }
}

class LegacyConfig extends DataFlow::Configuration {
  LegacyConfig() { this = "LegacyConfig" }

  override predicate isSource(DataFlow::Node source) { TestConfig::isSource(source) }

  override predicate isSink(DataFlow::Node sink) { TestConfig::isSink(sink) }

  override predicate isBarrierGuard(DataFlow::BarrierGuardNode node) {
    TestConfig::isBarrierGuard(node)
  }
}

import testUtilities.LegacyDataFlowDiff::DataFlowDiff<TestFlow, LegacyConfig>

query predicate flow = TestFlow::flow/2;
