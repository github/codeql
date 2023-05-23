import java
import semmle.code.java.dataflow.TaintTracking
import TestUtilities.InlineFlowTest
import semmle.code.java.dataflow.FlowSources

module SliceValueFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    DefaultFlowConfig::isSource(source) or source instanceof RemoteFlowSource
  }

  predicate isSink = DefaultFlowConfig::isSink/1;
}

module SliceValueFlow = DataFlow::Global<SliceValueFlowConfig>;

module SliceTaintFlowConfig implements DataFlow::ConfigSig {
  predicate isSource = DefaultFlowConfig::isSource/1;

  predicate isSink = DefaultFlowConfig::isSink/1;

  predicate allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet c) {
    DefaultFlowConfig::isSink(node) and
    c.(DataFlow::SyntheticFieldContent).getField() = "androidx.slice.Slice.action"
  }
}

module SliceTaintFlow = TaintTracking::Global<SliceTaintFlowConfig>;

class SliceFlowTest extends InlineFlowTest {
  override predicate hasValueFlow(DataFlow::Node source, DataFlow::Node sink) {
    SliceValueFlow::flow(source, sink)
  }

  override predicate hasTaintFlow(DataFlow::Node source, DataFlow::Node sink) {
    SliceTaintFlow::flow(source, sink)
  }
}
