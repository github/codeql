/**
 * @name Test for array creations
 */

import csharp

from Assignment a, ArrayCreation e, int i
where
  a.getLValue().(VariableAccess).getTarget().hasName("is5") and
  e = a.getRValue() and
  e.isImplicitlyTyped() and
  e.isImplicitlySized() and
  e.getArrayType().getDimension() = 1 and
  e.getArrayType().getRank() = 1 and
  e.getArrayType().getElementType() instanceof IntType and
  e.getInitializer().getNumberOfElements() = 4 and
  // Workaround for `e.getInitializer().getElement(2).getValue() = "100"`
  // until CORE-182 has been resolved
  e.getInitializer().getElement(i + 1).getValue() = "100" and
  i = 1
select e
