import java
import semmle.code.java.dataflow.TaintTracking
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

module TaintFlow = TaintTracking::Global<Config>;

module ValueFlow = DataFlow::Global<Config>;

class Test extends InlineFlowTest {
  override predicate hasTaintFlow(DataFlow::Node source, DataFlow::Node sink) {
    TaintFlow::flow(source, sink)
  }

  override predicate hasValueFlow(DataFlow::Node source, DataFlow::Node sink) {
    ValueFlow::flow(source, sink)
  }
}
