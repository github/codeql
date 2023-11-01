import java
import semmle.code.java.dataflow.FlowSources
import TestUtilities.InlineFlowTest

module ValueFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ThreatModelFlowSource }

  predicate isSink(DataFlow::Node sink) {
    sink.asExpr().(Argument).getCall().getCallee().hasName("sink")
  }
}

import FlowTest<ValueFlowConfig, DefaultFlowConfig>
