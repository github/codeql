import experimental.dataflow.tainttracking.TestTaintLib
import experimental.dataflow.RemoteFlowSources

class RemoteFlowTestTaintConfiguration extends TestTaintTrackingConfiguration {
  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }
}
