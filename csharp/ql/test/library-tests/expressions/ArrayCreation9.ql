/**
 * @name Test for array creations
 */

import csharp

from Assignment a, ArrayCreation e
where
  a.getLValue().(VariableAccess).getTarget().hasName("t") and
  e = a.getRValue() and
  e.isImplicitlyTyped() and
  e.isImplicitlySized() and
  e.getArrayType().getDimension() = 1 and
  e.getArrayType().getRank() = 1 and
  e.getArrayType().getElementType().hasName("Type") and
  e.getInitializer().getNumberOfElements() = 10 and
  e.getInitializer().getElement(0) instanceof TypeofExpr
select e
