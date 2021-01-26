/**
 * @name Access Of Memory Location After End Of Buffer
 * @description The expression `buffer [strlen (buffer)] = 0` is potentially dangerous, if the variable `buffer` does not have a terminal zero, then access beyond the bounds of the allocated memory is possible, which will lead to undefined behavior.
 *              If terminal zero is present, then the specified expression is meaningless.
 * @kind problem
 * @id cpp/access-memory-location-after-end-buffer
 * @problem.severity warning
 * @precision medium
 * @tags correctness
 *       security
 *       external/cwe/cwe-788
 */

import cpp
import semmle.code.cpp.valuenumbering.HashCons

from FunctionCall fc, AssignExpr expr, ArrayExpr exprarr
where
  fc.getTarget().hasGlobalOrStdName("strlen") and
  exprarr = expr.getLValue() and
  expr.getRValue().getValue().toInt() = 0 and
  exprarr.getArrayOffset() = fc and
  hashCons(fc.getArgument(0)) = hashCons(exprarr.getArrayBase())
select expr, "use a different method to calculate the length."
