import TestUtilities.dataflow.FlowTestCommon
private import semmle.code.cpp.ir.IR
private import semmle.code.cpp.ir.dataflow.TaintTracking

/** Common data flow configuration to be used by tests. */
module TestFoldedConstantConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asFoldedConstant() = any(MacroInvocation mi).getExpr().getValue()
  }

  predicate isSink(DataFlow::Node sink) {
    exists(FunctionCall call |
      call.getTarget().getName() = "sink" and
      sink.asExpr() = call.getAnArgument()
    )
  }
}

module TestFoldedConstant = TaintTracking::Global<TestFoldedConstantConfig>;

import MakeTest<IRFlowTest<TestFoldedConstant>>
