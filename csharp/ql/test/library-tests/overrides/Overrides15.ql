/**
 * @name Test for overrides
 */

import csharp

from Method m, Method n
where
  m.hasName("ToString") and
  m.getDeclaringType().hasName("C") and
  n.hasName("ToString") and
  n.getDeclaringType() instanceof ObjectType and
  m.getOverridee() = n
select m, n.toString()
