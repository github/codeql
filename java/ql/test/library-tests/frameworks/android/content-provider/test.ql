import java
import semmle.code.java.dataflow.FlowSources
import utils.test.InlineFlowTest

module ProviderTaintFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) { n instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node n) { DefaultFlowConfig::isSink(n) }

  int fieldFlowBranchLimit() { result = DefaultFlowConfig::fieldFlowBranchLimit() }
}

import TaintFlowTest<ProviderTaintFlowConfig>
