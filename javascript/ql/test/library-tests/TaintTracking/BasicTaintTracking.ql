import javascript
import semmle.javascript.dataflow.InferredTypes
deprecated import utils.test.ConsistencyChecking

DataFlow::CallNode getACall(string name) {
  result.getCalleeName() = name
  or
  result.getCalleeNode().getALocalSource() = DataFlow::globalVarRef(name)
}

module TestConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node = getACall("source") }

  predicate isSink(DataFlow::Node node) { node = getACall("sink").getAnArgument() }

  predicate isBarrier(DataFlow::Node node) {
    node.(DataFlow::InvokeNode).getCalleeName().matches("sanitizer_%") or
    node = DataFlow::MakeBarrierGuard<BasicSanitizerGuard>::getABarrierNode() or
    node = TaintTracking::AdHocWhitelistCheckSanitizer::getABarrierNode()
  }
}

module TestFlow = TaintTracking::Global<TestConfig>;

deprecated class LegacyConfig extends TaintTracking::Configuration {
  LegacyConfig() { this = "LegacyConfig" }

  override predicate isSource(DataFlow::Node node) { TestConfig::isSource(node) }

  override predicate isSink(DataFlow::Node node) { TestConfig::isSink(node) }

  override predicate isSanitizer(DataFlow::Node node) {
    node.(DataFlow::InvokeNode).getCalleeName().matches("sanitizer_%")
  }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode node) {
    node instanceof BasicSanitizerGuardLegacy or
    node instanceof TaintTracking::AdHocWhitelistCheckSanitizer
  }
}

deprecated import utils.test.LegacyDataFlowDiff::DataFlowDiff<TestFlow, LegacyConfig>

class BasicSanitizerGuard extends DataFlow::CallNode {
  BasicSanitizerGuard() { this = getACall("isSafe") }

  predicate blocksExpr(boolean outcome, Expr e) {
    outcome = true and e = this.getArgument(0).asExpr()
  }
}

deprecated class BasicSanitizerGuardLegacy extends TaintTracking::SanitizerGuardNode instanceof BasicSanitizerGuard
{
  override predicate sanitizes(boolean outcome, Expr e) { super.blocksExpr(outcome, e) }
}

query predicate flow = TestFlow::flow/2;

deprecated class Consistency extends ConsistencyConfiguration {
  Consistency() { this = "Consistency" }

  override DataFlow::Node getAnAlert() { TestFlow::flowTo(result) }
}
