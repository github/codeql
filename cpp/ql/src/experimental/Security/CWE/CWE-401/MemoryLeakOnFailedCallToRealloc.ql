/**
 * @name Memory leak on failed call to realloc
 * @description The expression mem = realloc (mem, size) is potentially dangerous, if the call fails, we will lose the pointer to the memory block.
 *	            An unsuccessful call is possible not only when trying to allocate a large amount of memory, but also when the process memory is strongly segmented.
 *              We recommend storing the result in a temporary variable and eliminating memory leak.
 * @kind problem
 * @id cpp/memory-leak-on-failed-call-to-realloc
 * @problem.severity warning
 * @precision medium
 * @tags security
 *       external/cwe/cwe-401
 */

import cpp
import semmle.code.cpp.dataflow.DataFlow

/**
 * A call to `realloc` of the form `v = realloc(v, size)`, for some variable `v`.
 */
class ReallocCallLeak extends FunctionCall {
  ReallocCallLeak() {
    exists(AssignExpr ex, Variable v, VariableAccess va1, VariableAccess va2 |
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
      exists(Variable v, DataFlow::Node source, DataFlow::Node sink |
        DataFlow::localFlow(source, sink) and
        source.asExpr() = this.getArgument(0) and
        this.getArgument(0) = v.getAnAccess() and
        ifc.getEnclosingFunction() = this.getEnclosingFunction() and
        ifc.getLocation().getStartLine() >= this.getArgument(0).getLocation().getStartLine() and
        v.getAnAccess() = ifc.getCondition().getAChild*() and
        sink.asExpr() = v.getAnAccess()
      ) and
      exists(FunctionCall fc |
        fc.getEnclosingFunction() = this.getEnclosingFunction() and
        fc.getTarget().hasName("exit") and
        (ifc.getThen().getAChild*() = fc or ifc.getElse().getAChild*() = fc)
      )
    )
  }

  predicate isExistsAssertWithArgumentCall() {
    exists(FunctionCall fc, Variable v, VariableAccess va1, VariableAccess va2 |
      fc.getTarget().hasName("assert") and
      this.getEnclosingFunction() = fc.getEnclosingFunction() and
      fc.getLocation().getStartLine() > this.getArgument(0).getLocation().getEndLine() and
      va2 = this.getArgument(0) and
      va1 = v.getAnAccess() and
      va2 = v.getAnAccess()
    )
  }
}

from ReallocCallLeak rcl
where
  not rcl.isExistsIfWithExitCall() and
  not rcl.isExistsAssertWithArgumentCall()
select rcl, "possible loss of original pointer on unsuccessful call realloc"
