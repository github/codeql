/**
 * @name Test for parameters
 */

import csharp

from Method m
where
  m.hasName("Divide") and
  m.getDeclaringType().hasQualifiedName("Methods.TestOut") and
  m.getParameter(0).isValue() and
  m.getParameter(0).hasName("x") and
  m.getParameter(0).getType() instanceof IntType and
  m.getParameter(1).isValue() and
  m.getParameter(1).hasName("y") and
  m.getParameter(1).getType() instanceof IntType and
  m.getParameter(2).isOut() and
  m.getParameter(2).hasName("result") and
  m.getParameter(2).getType() instanceof IntType and
  m.getParameter(3).isOut() and
  m.getParameter(3).hasName("remainder") and
  m.getParameter(3).getType() instanceof IntType
select m, m.getAParameter()
