/**
 * @name Test for parameters
 */

import csharp

from Method m
where
  m.hasName("Swap") and
  m.getDeclaringType().hasQualifiedName("Methods.TestRef") and
  m.getParameter(0).isRef() and
  m.getParameter(0).hasName("x") and
  m.getParameter(0).getType() instanceof IntType and
  m.getParameter(1).isRef() and
  m.getParameter(1).hasName("y") and
  m.getParameter(1).getType() instanceof IntType
select m, m.getAParameter()
