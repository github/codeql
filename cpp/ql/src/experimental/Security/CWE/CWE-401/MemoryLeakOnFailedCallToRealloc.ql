/**
 * @name Memory leak on failed call to realloc
 * @description The expression mem = realloc (mem, size) is potentially dangerous, if the call fails, we will lose the pointer to the memory block.
 *              We recommend storing the result in a temporary variable and eliminating memory leak.
 * @kind problem
 * @id cpp/memory-leak-on-failed-call-to-realloc
 * @problem.severity warning
 * @precision medium
 * @tags correctness
 *       security
 *       external/cwe/cwe-401
 */

import cpp

/**
 * A call to `realloc` of the form `v = realloc(v, size)`, for some variable `v`.
 */
class ReallocCallLeak extends FunctionCall {
  Variable v;

  ReallocCallLeak() {
    exists(AssignExpr ex, VariableAccess va1, VariableAccess va2 |
      this.getTarget().hasName("realloc") and
      this = ex.getRValue() and
      va1 = ex.getLValue() and
      va2 = this.getArgument(0) and
      va1 = v.getAnAccess() and
      va2 = v.getAnAccess()
    )
  }

  predicate isExistsIfWithExitCall() {
    exists(IfStmt ifc |
      this.getArgument(0) = v.getAnAccess() and
      ifc.getCondition().getAChild*() = v.getAnAccess() and
      ifc.getEnclosingFunction() = this.getEnclosingFunction() and
      ifc.getLocation().getStartLine() >= this.getArgument(0).getLocation().getStartLine() and
      exists(FunctionCall fc |
        fc.getTarget().hasName("exit") and
        fc.getEnclosingFunction() = this.getEnclosingFunction() and
        (ifc.getThen().getAChild*() = fc or ifc.getElse().getAChild*() = fc)
      )
      or
      exists(FunctionCall fc, FunctionCall ftmp1, FunctionCall ftmp2 |
        ftmp1.getTarget().hasName("exit") and
        ftmp2.(ControlFlowNode).getASuccessor*() = ftmp1 and
        fc = ftmp2.getEnclosingFunction().getACallToThisFunction() and
        fc.getEnclosingFunction() = this.getEnclosingFunction() and
        (ifc.getThen().getAChild*() = fc or ifc.getElse().getAChild*() = fc)
      )
    )
  }

  predicate isExistsAssertWithArgumentCall() {
    exists(FunctionCall fc |
      fc.getTarget().hasName("__assert_fail") and
      this.getEnclosingFunction() = fc.getEnclosingFunction() and
      fc.getLocation().getStartLine() > this.getArgument(0).getLocation().getEndLine() and
      fc.getArgument(0).toString().matches("%" + this.getArgument(0).toString() + "%")
    )
  }
}

from ReallocCallLeak rcl
where
  not rcl.isExistsIfWithExitCall() and
  not rcl.isExistsAssertWithArgumentCall()
select rcl, "possible loss of original pointer on unsuccessful call realloc"
