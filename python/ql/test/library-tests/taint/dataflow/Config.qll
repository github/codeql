import python
import semmle.python.dataflow.DataFlow

class TestConfiguration extends TaintTracking::Configuration {
  TestConfiguration() { this = "Test configuration" }

  override predicate isSource(DataFlow::Node source, TaintKind kind) {
    source.asCfgNode().(NameNode).getId() = "SOURCE" and kind instanceof DataFlowType
  }

  override predicate isSink(DataFlow::Node sink, TaintKind kind) {
    exists(CallNode call |
      call.getFunction().(NameNode).getId() = "SINK" and
      sink.asCfgNode() = call.getAnArg()
    ) and
    kind instanceof DataFlowType
  }
}

private class DataFlowType extends TaintKind {
  DataFlowType() { this = "Data flow" }
}
