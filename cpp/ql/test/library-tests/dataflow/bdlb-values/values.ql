import cpp
import utils.test.dataflow.FlowTestCommon
import semmle.code.cpp.ir.dataflow.DataFlow

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) {
    node.asExpr().(FunctionCall).getTarget().hasName("pointerSource")
  }

  predicate isSink(DataFlow::Node node) {
    exists(FunctionCall call |
      call.getTarget().hasName("pointerSink") and node.asExpr() = call.getArgument(0)
    )
  }
}

module Flow = DataFlow::Global<Config>;

module Results = IRFlowTest<Flow>;

module ValueTest implements TestSig {
  string getARelevantTag() { result = "value" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "value" and Results::hasActualResult(location, element, "ir", value)
  }
}

import MakeTest<ValueTest>
