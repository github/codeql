import java
import semmle.code.java.dataflow.FlowSources
import TestUtilities.InlineFlowTest

module SourceValueFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { DefaultFlowConfig::isSink(sink) }

  int fieldFlowBranchLimit() { result = DefaultFlowConfig::fieldFlowBranchLimit() }
}

module SourceValueFlow = DataFlow::Global<SourceValueFlowConfig>;

class SourceInlineFlowTest extends InlineFlowTest {
  override predicate hasValueFlow(DataFlow::Node src, DataFlow::Node sink) {
    SourceValueFlow::flow(src, sink)
  }

  override predicate hasTaintFlow(DataFlow::Node src, DataFlow::Node sink) { none() }
}
