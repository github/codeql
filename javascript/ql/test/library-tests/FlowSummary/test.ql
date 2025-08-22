import javascript
deprecated import utils.test.ConsistencyChecking
import utils.test.InlineSummaries

DataFlow::CallNode getACall(string name) {
  result.getCalleeName() = name
  or
  result.getCalleeNode().getALocalSource() = DataFlow::globalVarRef(name)
}

module ConfigArg implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node = getACall("source") }

  predicate isSink(DataFlow::Node node) { node = getACall("sink").getAnArgument() }

  predicate isBarrier(DataFlow::Node node) {
    node.(DataFlow::InvokeNode).getCalleeName().matches("sanitizer_%") or
    node = DataFlow::MakeBarrierGuard<BasicBarrierGuard>::getABarrierNode()
  }
}

module Configuration = DataFlow::Global<ConfigArg>;

class BasicBarrierGuard extends DataFlow::CallNode {
  BasicBarrierGuard() { this = getACall("isSafe") }

  predicate blocksExpr(boolean outcome, Expr e) {
    outcome = true and e = this.getArgument(0).asExpr()
  }
}

deprecated class ConsistencyConfig extends ConsistencyConfiguration {
  ConsistencyConfig() { this = "ConsistencyConfig" }

  override DataFlow::Node getAnAlert() { Configuration::flow(_, result) }
}
