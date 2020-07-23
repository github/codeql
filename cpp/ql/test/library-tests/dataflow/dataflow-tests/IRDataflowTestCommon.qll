import cpp
import semmle.code.cpp.ir.dataflow.DataFlow
import semmle.code.cpp.ir.IR

/**
 * A `BarrierGuard` that stops flow to all occurrences of `x` within statement
 * S in `if (guarded(x)) S`.
 */
// This is tested in `BarrierGuard.cpp`.
class TestBarrierGuard extends DataFlow::BarrierGuard {
  TestBarrierGuard() { this.(CallInstruction).getStaticCallTarget().getName() = "guarded" }

  override predicate checksInstr(Instruction checked, boolean isTrue) {
    checked = this.(CallInstruction).getPositionalArgument(0) and
    isTrue = true
  }
}

/** Common data flow configuration to be used by tests. */
class TestAllocationConfig extends DataFlow::Configuration {
  TestAllocationConfig() { this = "TestAllocationConfig" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr().(FunctionCall).getTarget().getName() = "source"
    or
    source.asParameter().getName().matches("source%")
    or
    // Track uninitialized variables
    exists(source.asUninitialized())
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(FunctionCall call |
      call.getTarget().getName() = "sink" and
      sink.asExpr() = call.getAnArgument()
    )
  }

  override predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
    exists(GlobalOrNamespaceVariable var | var.getName().matches("flowTestGlobal%") |
      writesVariable(n1.asInstruction(), var) and
      var = n2.asVariable()
      or
      readsVariable(n2.asInstruction(), var) and
      var = n1.asVariable()
    )
  }

  override predicate isBarrier(DataFlow::Node barrier) {
    barrier.asExpr().(VariableAccess).getTarget().hasName("barrier")
  }

  override predicate isBarrierGuard(DataFlow::BarrierGuard bg) { bg instanceof TestBarrierGuard }
}

private predicate readsVariable(LoadInstruction load, Variable var) {
  load.getSourceAddress().(VariableAddressInstruction).getASTVariable() = var
}

private predicate writesVariable(StoreInstruction store, Variable var) {
  store.getDestinationAddress().(VariableAddressInstruction).getASTVariable() = var
}
