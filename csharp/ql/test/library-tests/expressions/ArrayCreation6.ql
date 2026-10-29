/**
 * @name Test for array creations
 */

import csharp

from Assignment a, ArrayCreation e
where
  a.getLeftOperand().(VariableAccess).getTarget().hasName("is6") and
  e = a.getRightOperand() and
  e.isImplicitlyTyped() and
  e.isImplicitlySized() and
  e.getArrayType().getDimension() = 1 and
  e.getArrayType().getRank() = 1 and
  e.getArrayType().getElementType() instanceof DoubleType and
  e.getInitializer().getNumberOfElements() = 4 and
  e.getInitializer().getElement(1).getValue() = "1.5"
select e
