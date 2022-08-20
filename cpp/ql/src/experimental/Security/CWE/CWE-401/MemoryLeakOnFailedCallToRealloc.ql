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
import semmle.code.cpp.controlflow.Guards
import semmle.code.cpp.valuenumbering.HashCons

/**
 * A function call that potentially does not return (such as `exit`).
 */
class CallMayNotReturn extends FunctionCall {
  CallMayNotReturn() {
    // call that is known to not return
    not exists(this.(ControlFlowNode).getASuccessor())
    or
    // call to another function that may not return
    exists(CallMayNotReturn exit | this.getTarget() = exit.getEnclosingFunction())
  }
}

/**
 * A call to `realloc` of the form `v = realloc(v, size)`, for some variable `v`.
 */
class ReallocCallLeak extends FunctionCall {
  Variable v;

  ReallocCallLeak() {
    exists(AssignExpr ex |
      this.getTarget().hasGlobalOrStdName("realloc") and
      this = ex.getRValue() and
      hashCons(ex.getLValue()) = hashCons(this.getArgument(0)) and
      v.getAnAccess() = this.getArgument(0)
    )
  }

  /**
   * Holds if failure of this allocation may be handled by termination, for
   * example a call to `exit()`.
   */
  predicate mayHandleByTermination() {
    exists(GuardCondition guard, CallMayNotReturn exit |
      this.(ControlFlowNode).getASuccessor*() = guard and
      guard.getAChild*() = v.getAnAccess() and
      guard.controls(exit.getBasicBlock(), _)
    )
  }
}

from ReallocCallLeak rcl
where not rcl.mayHandleByTermination()
select rcl, "possible loss of original pointer on unsuccessful call realloc"
