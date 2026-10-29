/**
 * @name Test for delegates
 */

import csharp

from DelegateType d
where
  d.hasFullyQualifiedName("System.Threading", "ContextCallback") and
  d.getNumberOfParameters() = 1 and
  d.getParameter(0).hasName("state") and
  d.getParameter(0).isValue() and
  d.getParameter(0).getType() instanceof ObjectType and
  d.getReturnType() instanceof VoidType
select d.toString()
