import TestUtilities.dataflow.FlowTestCommon

module AstTest {
  private import semmle.code.cpp.dataflow.DataFlow

  /**
   * A `BarrierGuard` that stops flow to all occurrences of `x` within statement
   * S in `if (guarded(x)) S`.
   */
  // This is tested in `BarrierGuard.cpp`.
  class TestBarrierGuard extends DataFlow::BarrierGuard {
    TestBarrierGuard() { this.(FunctionCall).getTarget().getName() = "guarded" }

    override predicate checks(Expr checked, boolean isTrue) {
      checked = this.(FunctionCall).getArgument(0) and
      isTrue = true
    }
  }

  /** Common data flow configuration to be used by tests. */
  class AstTestAllocationConfig extends DataFlow::Configuration {
    AstTestAllocationConfig() { this = "ASTTestAllocationConfig" }

    override predicate isSource(DataFlow::Node source) {
      source.asExpr().(FunctionCall).getTarget().getName() = "source"
      or
      source.asParameter().getName().matches("source%")
      or
      source.(DataFlow::DefinitionByReferenceNode).getParameter().getName().matches("ref_source%")
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

    override predicate isBarrier(DataFlow::Node barrier) {
      barrier.asExpr().(VariableAccess).getTarget().hasName("barrier")
    }

    override predicate isBarrierGuard(DataFlow::BarrierGuard bg) { bg instanceof TestBarrierGuard }
  }
}

module IRTest {
  private import semmle.code.cpp.ir.dataflow.DataFlow
  private import semmle.code.cpp.ir.IR

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
  class IRTestAllocationConfig extends DataFlow::Configuration {
    IRTestAllocationConfig() { this = "IRTestAllocationConfig" }

    override predicate isSource(DataFlow::Node source) {
      source.asExpr().(FunctionCall).getTarget().getName() = "source"
      or
      source.asParameter().getName().matches("source%")
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
    load.getSourceAddress().(VariableAddressInstruction).getAstVariable() = var
  }

  private predicate writesVariable(StoreInstruction store, Variable var) {
    store.getDestinationAddress().(VariableAddressInstruction).getAstVariable() = var
  }
}
