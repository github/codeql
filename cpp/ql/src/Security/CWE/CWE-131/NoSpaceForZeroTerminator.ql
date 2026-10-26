/**
 * @name No space for zero terminator
 * @description Allocating a buffer using 'malloc' without ensuring that
 *              there is always space for the entire string and a zero
 *              terminator can cause a buffer overrun.
 * @kind problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision high
 * @id cpp/no-space-for-terminator
 * @tags reliability
 *       security
 *       external/cwe/cwe-131
 *       external/cwe/cwe-120
 *       external/cwe/cwe-122
 */

import cpp
import semmle.code.cpp.ir.dataflow.DataFlow
import semmle.code.cpp.models.interfaces.ArrayFunction
import semmle.code.cpp.models.interfaces.Allocation
import semmle.code.cpp.commons.NullTermination

predicate terminationProblem(HeuristicAllocationExpr malloc, string msg) {
  // malloc(strlen(...))
  exists(StrlenCall strlen | DataFlow::localExprFlow(strlen, malloc.getSizeExpr())) and
  // flows to a call that implies this is a null-terminated string
  exists(ArrayFunction af, FunctionCall fc, int arg |
    DataFlow::localExprFlow(malloc, fc.getArgument(arg)) and
    fc.getTarget() = af and
    (
      // flows into null terminated string argument
      af.hasArrayWithNullTerminator(arg)
      or
      // flows into likely null terminated string argument (such as `strcpy`, `strcat`)
      af.hasArrayWithUnknownSize(arg)
      or
      // flows into string argument to a formatting function (such as `printf`)
      formatArgumentMustBeNullTerminated(fc, fc.getArgument(arg))
    )
  ) and
  msg = "This allocation does not include space to null-terminate the string."
}

from Expr problem, string msg
where terminationProblem(problem, msg)
select problem, msg
