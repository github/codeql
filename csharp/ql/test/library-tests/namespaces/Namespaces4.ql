/**
 * @name Test for namespaces
 */

import csharp

from Namespace n, Class a, Class b
where
  n.hasQualifiedName("M1.M2") and
  a = n.getAClass() and
  a.hasName("A") and
  a.isPublic() and
  b = n.getAClass() and
  b.hasName("B") and
  b.isInternal()
select n
