import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.FlowSources
import TestUtilities.InlineFlowTest

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) {
    DefaultFlowConfig::isSource(node)
    or
    node instanceof RemoteFlowSource
  }

  predicate isSink = DefaultFlowConfig::isSink/1;
}

module Flow = TaintTracking::Global<Config>;

class Test extends InlineFlowTest {
  override predicate hasTaintFlow(DataFlow::Node source, DataFlow::Node sink) {
    Flow::flow(source, sink)
  }
}
