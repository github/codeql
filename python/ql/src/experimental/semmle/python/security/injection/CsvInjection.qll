import python
import experimental.semmle.python.Concepts
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.BarrierGuards
import semmle.python.dataflow.new.RemoteFlowSources

/**
 * A taint-tracking configuration for tracking untrusted user input used in file read.
 */
class CsvInjectionFlowConfig extends TaintTracking::Configuration {
  CsvInjectionFlowConfig() { this = "CsvInjectionFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink = any(CsvWriter cw).getAnInput() }

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof StartsWithCheck or
    guard instanceof StringConstCompare
  }
}

private class StartsWithCheck extends DataFlow::BarrierGuard {
  DataFlow::MethodCallNode mc;

  StartsWithCheck() {
    this = mc.asCfgNode() and
    mc.calls(_, "startswith")
  }

  override predicate checks(ControlFlowNode node, boolean branch) {
    node = mc.getObject().asCfgNode() and
    branch = true
  }
}
