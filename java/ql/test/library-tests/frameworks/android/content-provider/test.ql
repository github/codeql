import java
import semmle.code.java.dataflow.FlowSources
import TestUtilities.InlineFlowTest

module ProviderTaintFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) { n instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node n) { DefaultFlowConfig::isSink(n) }

  int fieldFlowBranchLimit() { result = DefaultFlowConfig::fieldFlowBranchLimit() }
}

module ProviderTaintFlow = TaintTracking::Global<ProviderTaintFlowConfig>;

class ProviderInlineFlowTest extends InlineFlowTest {
  override predicate hasValueFlow(DataFlow::Node src, DataFlow::Node sink) { none() }

  override predicate hasTaintFlow(DataFlow::Node src, DataFlow::Node sink) {
    ProviderTaintFlow::flow(src, sink)
  }
}
