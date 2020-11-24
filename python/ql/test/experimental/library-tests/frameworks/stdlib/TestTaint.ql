import experimental.dataflow.tainttracking.TestTaintLib
import semmle.python.dataflow.new.RemoteFlowSources

class WithRemoteFlowSources extends TestTaintTrackingConfiguration {
  override predicate isSource(DataFlow::Node source) {
    super.isSource(source) or
    source instanceof RemoteFlowSource
  }
}
