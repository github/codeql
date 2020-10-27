import cpp
import semmle.code.cpp.ir.IR
import semmle.code.cpp.ir.dataflow.TaintTracking

/** Common data flow configuration to be used by tests. */
class TestAllocationConfig extends TaintTracking::Configuration {
  TestAllocationConfig() { this = "TestAllocationConfig" }

  override predicate isSource(DataFlow::Node source) {
    source.(DataFlow::ExprNode).getConvertedExpr().(FunctionCall).getTarget().getName() = "source"
    or
    source.asParameter().getName().matches("source%")
    or
    // Track uninitialized variables
    exists(source.asUninitialized())
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(FunctionCall call |
      call.getTarget().getName() = "sink" and
      sink.(DataFlow::ExprNode).getConvertedExpr() = call.getAnArgument()
      or
      call.getTarget().getName() = "sink" and
      sink.asExpr() = call.getAnArgument() and
      sink.(DataFlow::ExprNode).getConvertedExpr() instanceof ReferenceDereferenceExpr
    )
    or
    exists(ReadSideEffectInstruction read |
      read.getSideEffectOperand() = sink.asOperand() and
      read.getPrimaryInstruction().(CallInstruction).getStaticCallTarget().hasName("sink")
    )
  }

  override predicate isSanitizer(DataFlow::Node barrier) {
    barrier.asExpr().(VariableAccess).getTarget().hasName("sanitizer")
  }
}
