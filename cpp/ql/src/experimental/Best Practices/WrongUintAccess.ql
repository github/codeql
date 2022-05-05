/**
 * @id cpp/wrong-uint-access
 * @name Wrong Uint
 * @descripion Acess an array of size lower than 256 with a uint16.
 * @kind problem
 * @problem.severity recommendation
 * @tags efficiency
 */

import cpp

from
  Variable var, ArrayExpr useExpr, VariableDeclarationEntry def, ArrayType defLine, VariableAccess use
where
  def = defLine.getATypeNameUse() and
  var = def.getDeclaration() and
  use = useExpr.getArrayBase() and
  var = use.getTarget() and (
  (useExpr.getArrayOffset().getType() instanceof UInt16_t and
  defLine.getArraySize() <= 256) or
  (useExpr.getArrayOffset().getType() instanceof UInt32_t and
  defLine.getArraySize() <= 900) or
  (useExpr.getArrayOffset().getType() instanceof UInt64_t and
  defLine.getArraySize() <= 1000)
  )
select useExpr, "Using a " + useExpr.getArrayOffset().getType() +" to acess the array $@ of size " + defLine.getArraySize() + ".", var,
  var.getName()
