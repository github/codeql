import java
import semmle.code.java.dataflow.FlowSources
import TestUtilities.InlineFlowTest

module SourceValueFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src instanceof ThreatModelFlowSource }

  predicate isSink(DataFlow::Node sink) { DefaultFlowConfig::isSink(sink) }

  int fieldFlowBranchLimit() { result = DefaultFlowConfig::fieldFlowBranchLimit() }
}

import ValueFlowTest<SourceValueFlowConfig>
