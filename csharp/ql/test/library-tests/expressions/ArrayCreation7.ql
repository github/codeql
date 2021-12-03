/**
 * @name Test for array creations
 */

import csharp

from Assignment a, ArrayCreation e
where
  a.getLValue().(VariableAccess).getTarget().hasName("is7") and
  e = a.getRValue() and
  e.isImplicitlyTyped() and
  e.isImplicitlySized() and
  e.getArrayType().getDimension() = 1 and
  e.getArrayType().getRank() = 2 and
  e.getArrayType().getElementType() instanceof StringType and
  e.getInitializer().getNumberOfElements() = 2 and
  e.getInitializer().getElement(0).(ArrayInitializer).getElement(1).getValue() = "null"
select e
