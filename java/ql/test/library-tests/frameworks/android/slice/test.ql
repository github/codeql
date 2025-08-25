import java
import semmle.code.java.dataflow.TaintTracking
import utils.test.InlineFlowTest
import semmle.code.java.dataflow.FlowSources

module SliceValueFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    DefaultFlowConfig::isSource(source) or source instanceof ActiveThreatModelSource
  }

  predicate isSink = DefaultFlowConfig::isSink/1;
}

module SliceTaintFlowConfig implements DataFlow::ConfigSig {
  predicate isSource = DefaultFlowConfig::isSource/1;

  predicate isSink = DefaultFlowConfig::isSink/1;

  predicate allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet c) {
    DefaultFlowConfig::isSink(node) and
    c.(DataFlow::SyntheticFieldContent).getField() = "androidx.slice.Slice.action"
  }
}

import FlowTest<SliceValueFlowConfig, SliceTaintFlowConfig>
