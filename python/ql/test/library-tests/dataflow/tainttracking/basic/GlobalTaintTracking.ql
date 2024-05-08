import python
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.DataFlow

module TestTaintTrackingConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.(DataFlow::CfgNode).getNode().(NameNode).getId() = "SOURCE"
  }

  predicate isSink(DataFlow::Node sink) {
    exists(CallNode call |
      call.getFunction().(NameNode).getId() = "SINK" and
      sink.(DataFlow::CfgNode).getNode() = call.getAnArg()
    )
  }
}

module TestTaintTrackingFlow = DataFlow::Global<TestTaintTrackingConfig>;

from DataFlow::Node source, DataFlow::Node sink
where TestTaintTrackingFlow::flow(source, sink)
select source, sink
