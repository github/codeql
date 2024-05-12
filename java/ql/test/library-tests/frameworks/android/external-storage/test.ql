import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.FlowSources
import TestUtilities.InlineFlowTest

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src instanceof ThreatModelFlowSource }

  predicate isSink(DataFlow::Node sink) {
    sink.asExpr().(Argument).getCall().getCallee().hasName("sink")
  }
}

import TaintFlowTest<Config>
