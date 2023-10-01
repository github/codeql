import TestUtilities.dataflow.FlowTestCommon

module AstTest {
  private import semmle.code.cpp.dataflow.DataFlow
  private import semmle.code.cpp.controlflow.Guards

  /**
   * A `BarrierGuard` that stops flow to all occurrences of `x` within statement
   * S in `if (guarded(x)) S`.
   */
  // This is tested in `BarrierGuard.cpp`.
  predicate testBarrierGuard(GuardCondition g, Expr checked, boolean isTrue) {
    g.(FunctionCall).getTarget().getName() = "guarded" and
    checked = g.(FunctionCall).getArgument(0) and
    isTrue = true
  }

  /** Common data flow configuration to be used by tests. */
  module AstTestAllocationConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) {
      source.asExpr().(FunctionCall).getTarget().getName() = "source"
      or
      source.asParameter().getName().matches("source%")
      or
      source.asExpr().(FunctionCall).getTarget().getName() = "indirect_source"
      or
      source.(DataFlow::DefinitionByReferenceNode).getParameter().getName().matches("ref_source%")
      or
      // Track uninitialized variables
      exists(source.asUninitialized())
    }

    predicate isSink(DataFlow::Node sink) {
      exists(FunctionCall call |
        call.getTarget().getName() = ["sink", "indirect_sink"] and
        sink.asExpr() = call.getAnArgument()
      )
    }

    predicate isBarrier(DataFlow::Node barrier) {
      barrier.asExpr().(VariableAccess).getTarget().hasName("barrier") or
      barrier = DataFlow::BarrierGuard<testBarrierGuard/3>::getABarrierNode()
    }
  }

  module AstFlow = DataFlow::Global<AstTestAllocationConfig>;
}

module IRTest {
  private import cpp
  private import semmle.code.cpp.ir.dataflow.DataFlow
  private import semmle.code.cpp.ir.IR
  private import semmle.code.cpp.controlflow.IRGuards

  /**
   * A `BarrierGuard` that stops flow to all occurrences of `x` within statement
   * S in `if (guarded(x)) S`.
   */
  // This is tested in `BarrierGuard.cpp`.
  predicate testBarrierGuard(IRGuardCondition g, Expr checked, boolean isTrue) {
    exists(Call call |
      call = g.getUnconvertedResultExpression() and
      call.getTarget().hasName("guarded") and
      checked = call.getArgument(0) and
      isTrue = true
    )
  }

  /** Common data flow configuration to be used by tests. */
  module IRTestAllocationConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) {
      source.asExpr().(FunctionCall).getTarget().getName() = "source"
      or
      source.asIndirectExpr(1).(FunctionCall).getTarget().getName() = "indirect_source"
      or
      source.asParameter().getName().matches("source%")
      or
      source.(DataFlow::DefinitionByReferenceNode).getParameter().getName().matches("ref_source%")
      or
      exists(source.asUninitialized())
    }

    predicate isSink(DataFlow::Node sink) {
      exists(FunctionCall call, Expr e | e = call.getAnArgument() |
        call.getTarget().getName() = "sink" and
        sink.asExpr() = e
        or
        call.getTarget().getName() = "indirect_sink" and
        sink.asIndirectExpr() = e
      )
    }

    predicate isBarrier(DataFlow::Node barrier) {
      exists(Expr barrierExpr | barrierExpr in [barrier.asExpr(), barrier.asIndirectExpr()] |
        barrierExpr.(VariableAccess).getTarget().hasName("barrier")
      )
      or
      barrier = DataFlow::BarrierGuard<testBarrierGuard/3>::getABarrierNode()
      or
      barrier = DataFlow::BarrierGuard<testBarrierGuard/3>::getAnIndirectBarrierNode()
    }
  }

  module IRFlow = DataFlow::Global<IRTestAllocationConfig>;
}

import MakeTest<MergeTests<AstFlowTest<AstTest::AstFlow>, IRFlowTest<IRTest::IRFlow>>>
