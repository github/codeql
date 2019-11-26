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
import semmle.code.cpp.models.interfaces.ArrayFunction

class MallocCall extends FunctionCall {
  MallocCall() { this.getTarget().hasGlobalOrStdName("malloc") }

  Expr getAllocatedSize() { result = this.getArgument(0) }
}

predicate terminationProblem(MallocCall malloc, string msg) {
  // malloc(strlen(...))
  exists(StrlenCall strlen | DataFlow::localExprFlow(strlen, malloc.getAllocatedSize())) and
  // flows into a null-terminated string function
  exists(ArrayFunction af, FunctionCall fc, int arg |
    DataFlow::localExprFlow(malloc, fc.getArgument(arg)) and
    fc.getTarget() = af and
    (
      // null terminated string
      af.hasArrayWithNullTerminator(arg)
      or
      // likely a null terminated string (such as `strcpy`, `strcat`)
      af.hasArrayWithUnknownSize(arg)
    )
  ) and
  msg = "This allocation does not include space to null-terminate the string."
}

from Expr problem, string msg
where terminationProblem(problem, msg)
select problem, msg
