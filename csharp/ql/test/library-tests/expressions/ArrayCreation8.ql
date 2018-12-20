/**
 * @name Test for array creations
 */

import csharp

from Assignment a, ArrayCreation e
where
  a.getLValue().(VariableAccess).getTarget().hasName("contacts2") and
  e = a.getRValue() and
  e.isImplicitlyTyped() and
  e.isImplicitlySized() and
  e.getArrayType().getDimension() = 1 and
  e.getArrayType().getRank() = 1 and
  e.getArrayType().getElementType() instanceof AnonymousClass and
  e.getInitializer().getNumberOfElements() = 2 and
  e.getInitializer().getElement(0) instanceof AnonymousObjectCreation
select e
