/**
 * @name Test for array creations
 */

import csharp

from Assignment a, ArrayCreation e
where
  a.getLValue().(VariableAccess).getTarget().hasName("is4") and
  e = a.getRValue() and
  not e.isImplicitlyTyped() and
  not e.hasInitializer() and
  e.getNumberOfLengthArguments() = 2 and
  e.getLengthArgument(0).getValue() = "100" and
  e.getLengthArgument(1).getValue() = "5" and
  e.getArrayType().getDimension() = 1 and
  e.getArrayType().getRank() = 2 and
  e.getArrayType().getElementType() instanceof IntType
select e
