/**
 * @name No space for zero terminator
 * @description Allocating a buffer using 'malloc' without ensuring that
 *              there is always space for the entire string and a zero
 *              terminator can cause a buffer overrun.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cpp/no-space-for-terminator
 * @tags reliability
 *       security
 *       external/cwe/cwe-131
 *       external/cwe/cwe-120
 *       external/cwe/cwe-122
 */

import cpp
import semmle.code.cpp.dataflow.DataFlow
import semmle.code.cpp.models.implementations.Memcpy

class MallocCall extends FunctionCall {
  MallocCall() {
    this.getTarget().hasGlobalName("malloc") or
    this.getTarget().hasQualifiedName("std", "malloc")
  }

  Expr getAllocatedSize() {
    if this.getArgument(0) instanceof VariableAccess
    then
      exists(LocalScopeVariable v, ControlFlowNode def |
        definitionUsePair(v, def, this.getArgument(0)) and
        exprDefinition(v, def, result)
      )
    else result = this.getArgument(0)
  }
}

predicate terminationProblem(MallocCall malloc, string msg) {
  malloc.getAllocatedSize() instanceof StrlenCall and
  not exists(FunctionCall fc, MemcpyFunction memcpy, int ix |
    DataFlow::localExprFlow(malloc, fc.getArgument(ix)) and
    fc.getTarget() = memcpy and
    memcpy.hasArrayOutput(ix)
  ) and
  msg = "This allocation does not include space to null-terminate the string."
}

from Expr problem, string msg
where terminationProblem(problem, msg)
select problem, msg
