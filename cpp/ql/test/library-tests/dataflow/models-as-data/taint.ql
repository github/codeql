import utils.test.dataflow.FlowTestCommon
import testModels

module IRTest {
  private import semmle.code.cpp.ir.IR
  private import semmle.code.cpp.ir.dataflow.TaintTracking

  /** Common data flow configuration to be used by tests. */
  module TestAllocationConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) {
      source instanceof FlowSource
      or
      source.asExpr().(FunctionCall).getTarget().getName() =
        ["source", "source2", "source3", "sourcePtr"]
      or
      source.asIndirectExpr(1).(FunctionCall).getTarget().getName() = "sourceIndirect"
    }

    predicate isSink(DataFlow::Node sink) {
      sinkNode(sink, "test-sink")
      or
      exists(FunctionCall call |
        call.getTarget().getName() = "sink" and
        sink.asExpr() = call.getAnArgument()
      )
    }
  }

  module IRFlow = TaintTracking::Global<TestAllocationConfig>;
}

import MakeTest<IRFlowTest<IRTest::IRFlow>>
