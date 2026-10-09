import cpp
import utils.test.dataflow.FlowTestCommon
import semmle.code.cpp.ir.dataflow.TaintTracking

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) {
    node.asExpr().(FunctionCall).getTarget().hasName("source")
  }

  predicate isSink(DataFlow::Node node) {
    exists(FunctionCall call |
      call.getTarget().hasName("sink") and node.asExpr() = call.getArgument(0)
    )
  }
}

module Flow = TaintTracking::Global<Config>;

import MakeTest<IRFlowTest<Flow>>
