import utils.test.dataflow.FlowTestCommon

module AstTest {
  private import semmle.code.cpp.dataflow.TaintTracking

  module AstSmartPointerTaintConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) {
      source.asExpr().(FunctionCall).getTarget().getName() = "source"
    }

    predicate isSink(DataFlow::Node sink) {
      exists(FunctionCall call |
        call.getTarget().getName() = "sink" and
        sink.asExpr() = call.getAnArgument()
      )
    }
  }

  module AstFlow = TaintTracking::Global<AstSmartPointerTaintConfig>;
}

module IRTest {
  private import semmle.code.cpp.ir.dataflow.TaintTracking

  module IRSmartPointerTaintConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) {
      source.asExpr().(FunctionCall).getTarget().getName() = "source"
    }

    predicate isSink(DataFlow::Node sink) {
      exists(FunctionCall call |
        call.getTarget().getName() = "sink" and
        sink.asExpr() = call.getAnArgument()
      )
    }
  }

  module IRFlow = TaintTracking::Global<IRSmartPointerTaintConfig>;
}

import MakeTest<MergeTests<AstFlowTest<AstTest::AstFlow>, IRFlowTest<IRTest::IRFlow>>>
