module AstTest {
  import semmle.code.cpp.dataflow.DataFlow
  private import semmle.code.cpp.controlflow.Guards

  /**
   * A `BarrierGuard` that stops flow to all occurrences of `x` within statement
   * S in `if (guarded(x)) S`.
   */
  // This is tested in `BarrierGuard.cpp`.
  predicate testBarrierGuard(GuardCondition g, Expr checked, boolean branch) {
    exists(Call call, boolean b |
      checked = call.getArgument(0) and
      g.comparesEq(call, 0, b, any(BooleanValue bv | bv.getValue() = branch))
    |
      call.getTarget().hasName("guarded") and
      b = false
      or
      call.getTarget().hasName("unsafe") and
      b = true
    )
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
  import semmle.code.cpp.ir.dataflow.DataFlow
  private import semmle.code.cpp.ir.IR
  private import semmle.code.cpp.controlflow.IRGuards
  private import semmle.code.cpp.models.interfaces.DataFlow

  boolean isOne(string s) {
    s = "1" and result = true
    or
    s = "0" and result = false
  }

  /**
   * A model of a test function called `strdup_ptr_xyz` where `x, y, z in {0, 1}`.
   * `x` is 1 if there's flow from the argument to the function return,
   * `y` is 1 if there's flow from the first indirection of the argument to
   * the first indirection of the function return, and
   * `z` is 1 if there's flow from the second indirection of the argument to
   * the second indirection of the function return.
   */
  class StrDupPtr extends DataFlowFunction {
    boolean argToReturnFlow;
    boolean argIndToReturnInd;
    boolean argIndInToReturnIndInd;

    StrDupPtr() {
      exists(string r |
        r = "strdup_ptr_([01])([01])([01])" and
        argToReturnFlow = isOne(this.getName().regexpCapture(r, 1)) and
        argIndToReturnInd = isOne(this.getName().regexpCapture(r, 2)) and
        argIndInToReturnIndInd = isOne(this.getName().regexpCapture(r, 3))
      )
    }

    /**
     * Flow from `**ptr` to `**return`
     */
    override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
      argToReturnFlow = true and
      input.isParameter(0) and
      output.isReturnValue()
      or
      argIndToReturnInd = true and
      input.isParameterDeref(0, 1) and
      output.isReturnValueDeref(1)
      or
      argIndInToReturnIndInd = true and
      input.isParameterDeref(0, 2) and
      output.isReturnValueDeref(2)
    }
  }

  /**
   * A `BarrierGuard` that stops flow to all occurrences of `x` within statement
   * S in `if (guarded(x)) S`.
   */
  // This is tested in `BarrierGuard.cpp`.
  predicate testBarrierGuard(IRGuardCondition g, Expr checked, boolean branch) {
    exists(CallInstruction call, boolean b |
      checked = call.getArgument(0).getUnconvertedResultExpression() and
      g.comparesEq(call.getAUse(), 0, b, any(BooleanValue bv | bv.getValue() = branch))
    |
      call.getStaticCallTarget().hasName("guarded") and
      b = false
      or
      call.getStaticCallTarget().hasName("unsafe") and
      b = true
    )
  }

  /** Common data flow configuration to be used by tests. */
  module IRTestAllocationConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) {
      source.asExpr().(FunctionCall).getTarget().getName() = "source"
      or
      source.asIndirectExpr(1).(FunctionCall).getTarget().getName() = "indirect_source"
      or
      source.asExpr().(StringLiteral).getValue() = "source"
      or
      // indirect_source(n) gives the dataflow node representing the indirect node after n dereferences.
      exists(int n, string s |
        n = s.regexpCapture("indirect_source\\((\\d)\\)", 1).toInt() and
        source.asIndirectExpr(n).(StringLiteral).getValue() = s
      )
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
        or
        call.getTarget().getName() = "indirect_sink_const_ref" and
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
