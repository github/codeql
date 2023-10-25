import java
import semmle.code.java.dataflow.FlowSources
import TestUtilities.InlineFlowTest

module ProviderTaintFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) { n instanceof ThreatModelFlowSource }

  predicate isSink(DataFlow::Node n) { DefaultFlowConfig::isSink(n) }

  int fieldFlowBranchLimit() { result = DefaultFlowConfig::fieldFlowBranchLimit() }
}

import TaintFlowTest<ProviderTaintFlowConfig>
