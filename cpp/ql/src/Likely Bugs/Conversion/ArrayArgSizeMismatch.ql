/**
 * @name Array argument size mismatch
 * @description Finds function calls where the size of an array being passed is smaller than the array size of the declared parameter.
 *              This could lead to accesses to memory locations beyond the parameter's array bounds.
 * @kind problem
 * @id cpp/array-arg-size-mismatch
 * @problem.severity warning
 * @precision high
 * @tags reliability
 */

import cpp
import semmle.code.cpp.commons.Buffer

from Function f, FunctionCall c, int i, ArrayType argType, ArrayType paramType, int a, int b
where
  f = c.getTarget() and
  argType = c.getArgument(i).getType() and
  paramType = f.getParameter(i).getType() and
  a = argType.getArraySize() and
  b = paramType.getArraySize() and
  argType.getBaseType().getSize() = paramType.getBaseType().getSize() and
  a < b and
  not memberMayBeVarSize(_, c.getArgument(i).(VariableAccess).getTarget()) and
  // filter out results for inconsistent declarations
  strictcount(f.getParameter(i).getType().getSize()) = 1
select c.getArgument(i),
  "Array of size " + a + " passed to $@ which expects an array of size " + b + ".", f, f.getName()
