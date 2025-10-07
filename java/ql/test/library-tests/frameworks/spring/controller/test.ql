import java
import semmle.code.java.dataflow.FlowSources
import utils.test.InlineFlowTest

module ValueFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) {
    sink.asExpr().(Argument).getCall().getCallee().hasName("sink")
  }
}

import FlowTest<ValueFlowConfig, DefaultFlowConfig>
