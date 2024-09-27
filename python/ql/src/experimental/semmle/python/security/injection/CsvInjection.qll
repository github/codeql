import python
import experimental.semmle.python.Concepts
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.BarrierGuards
import semmle.python.dataflow.new.RemoteFlowSources

/**
 * A taint-tracking configuration for tracking untrusted user input used in file read.
 */
private module CsvInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink = any(CsvWriter cw).getAnInput() }

  predicate isBarrier(DataFlow::Node node) {
    node = DataFlow::BarrierGuard<startsWithCheck/3>::getABarrierNode() or
    node instanceof ConstCompareBarrier
  }
}

private predicate startsWithCheck(DataFlow::GuardNode g, ControlFlowNode node, boolean branch) {
  exists(DataFlow::MethodCallNode mc |
    g = mc.asCfgNode() and
    mc.calls(_, "startswith") and
    node = mc.getObject().asCfgNode() and
    branch = true
  )
}

/** Global taint-tracking for detecting "CSV injection" vulnerabilities. */
module CsvInjectionFlow = TaintTracking::Global<CsvInjectionConfig>;
