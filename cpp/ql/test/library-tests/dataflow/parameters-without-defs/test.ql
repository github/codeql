import utils.test.dataflow.FlowTestCommon
import semmle.code.cpp.dataflow.new.DataFlow

module ParamConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source.asExpr().(Call).getTarget().hasName("source") }

  predicate isSink(DataFlow::Node sink) {
    sink.asParameter().getFunction().hasName("sink")
    or
    sink.asParameter(1).getFunction().hasName("indirect_sink")
  }
}

module IRFlow = DataFlow::Global<ParamConfig>;

import MakeTest<IRFlowTest<IRFlow>>
