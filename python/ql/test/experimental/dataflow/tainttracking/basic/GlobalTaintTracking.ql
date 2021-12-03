import python
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.DataFlow

class TestTaintTrackingConfiguration extends TaintTracking::Configuration {
  TestTaintTrackingConfiguration() { this = "TestTaintTrackingConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    source.(DataFlow::CfgNode).getNode().(NameNode).getId() = "SOURCE"
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(CallNode call |
      call.getFunction().(NameNode).getId() = "SINK" and
      sink.(DataFlow::CfgNode).getNode() = call.getAnArg()
    )
  }
}

from TestTaintTrackingConfiguration config, DataFlow::Node source, DataFlow::Node sink
where config.hasFlow(source, sink)
select source, sink
