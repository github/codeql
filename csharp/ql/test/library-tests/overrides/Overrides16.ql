/**
 * @name Test for overrides
 */

import csharp

from Method m, Method n
where
  m.hasName("Add") and
  m.getDeclaringType().hasName("List<>") and
  n.hasName("Add") and
  n.getDeclaringType().hasName("ICollection<T>") and
  m.getImplementee() = n
select m.toString(), n.toString()
