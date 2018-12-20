/**
 * @name Test for array creations
 */

import csharp

from Assignment a, ArrayCreation e
where
  a.getLValue().(VariableAccess).getTarget().hasName("is3") and
  e = a.getRValue() and
  not e.isImplicitlyTyped() and
  not e.hasInitializer() and
  e.getNumberOfLengthArguments() = 1 and
  e.getLengthArgument(0).getValue() = "100" and
  e.getArrayType().getDimension() = 2 and
  e.getArrayType().getRank() = 1 and
  e.getArrayType().getElementType().(ArrayType).getElementType() instanceof IntType
select e
