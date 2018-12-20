/**
 * @name Test for array creations
 */

import csharp

from Assignment a, ArrayCreation e, CastExpr cast
where
  a.getLValue().(VariableAccess).getTarget().hasName("os") and
  e.getEnclosingCallable().hasName("MainElementAccess") and
  e = a.getRValue() and
  not e.isImplicitlyTyped() and
  e.isImplicitlySized() and
  e.getArrayType().getDimension() = 1 and
  e.getArrayType().getRank() = 1 and
  e.getInitializer().getNumberOfElements() = 1 and
  e.getInitializer().getElement(0) = cast and
  cast.getExpr() instanceof ParameterAccess
select e, e.getInitializer().getElement(0)
