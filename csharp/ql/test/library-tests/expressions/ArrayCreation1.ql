/**
 * @name Test for array creations
 */

import csharp

from Assignment a, ArrayCreation e, ArrayInitializer i
where
  a.getLValue().(VariableAccess).getTarget().hasName("is1") and
  e = a.getRValue() and
  not e.isImplicitlyTyped() and
  i = e.getInitializer() and
  e.isImplicitlySized() and
  e.getArrayType().getDimension() = 1 and
  e.getArrayType().getRank() = 2 and
  e.getArrayType().getElementType() instanceof IntType and
  i.getNumberOfElements() = 3 and
  i.getElement(0).(ArrayInitializer).getNumberOfElements() = 2 and
  i.getElement(0).(ArrayInitializer).getElement(0).getValue() = "0"
select e, i
