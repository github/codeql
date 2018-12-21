/**
 * @name Test for generics
 */

import csharp

from Class c
where
  c.hasName("Subtle") and
  count(c.getAMethod()) = 3
select c, c.getAMethod()
