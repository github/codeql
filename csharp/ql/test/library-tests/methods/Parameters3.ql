/**
 * @name Test for parameters
 */

import csharp

from Method m
where
  m.hasName("Write") and
  m.getDeclaringType().hasFullyQualifiedName("Methods", "Console") and
  m.getParameter(0).isValue() and
  m.getParameter(0).hasName("fmt") and
  m.getParameter(0).getType() instanceof StringType and
  m.getParameter(1).isParams() and
  m.getParameter(1).hasName("args") and
  m.getParameter(1).getType().(ArrayType).getElementType() instanceof ObjectType
select m, m.getAParameter().getType().toString()
