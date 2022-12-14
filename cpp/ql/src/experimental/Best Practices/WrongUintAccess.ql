/**
 * @id cpp/wrong-uint-access
 * @name Wrong Uint
 * @description Access an array of size lower than 256 with a uint16.
 * @kind problem
 * @problem.severity recommendation
 * @tags efficiency
 */

import cpp

from Variable var, ArrayExpr useExpr, ArrayType defLine, VariableAccess use
where
  var.getUnspecifiedType() = defLine and
  use = useExpr.getArrayBase() and
  var = use.getTarget() and
  (
    useExpr.getArrayOffset().getType() instanceof UInt16_t or
    useExpr.getArrayOffset().getType() instanceof UInt32_t or
    useExpr.getArrayOffset().getType() instanceof UInt64_t
  ) and
  defLine.getArraySize() <= 256
select useExpr,
  "Using a " + useExpr.getArrayOffset().getType() + " to access the array $@ of size " +
    defLine.getArraySize() + ".", var, var.getName()
