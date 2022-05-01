/**
 * @id cpp/wrong-uint-access
 * @name Wrong Uint
 * @descripion Acess an array of size lower than 256 with a uint16.
 * @kind problem
 * @problem.severity recommendation
 * @tags efficiency
 */

import cpp
import semmle.code.cpp.controlflow.SSA

from
  Variable E, ArrayExpr useExpr, ArrayType defExpr, VariableDeclarationEntry def, VariableAccess use
where
  def = defExpr.getATypeNameUse() and
  E = def.getDeclaration() and
  use = useExpr.getArrayBase() and
  E = use.getTarget() and
  useExpr.getArrayOffset().getType() instanceof UInt16_t and
  defExpr.getArraySize() <= 256
select useExpr, "Using a UInt16_t to acess the array $@ of size " + defExpr.getArraySize() + ".", E,
  E.getName()
