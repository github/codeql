import experimental.dataflow.tainttracking.TestTaintLib
import semmle.python.dataflow.new.RemoteFlowSources

class RemoteFlowTestTaintConfiguration extends TestTaintTrackingConfiguration {
  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }
}
