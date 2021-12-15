/**
 * @name Test for methods
 */

import csharp

from Class c
where
  c.hasName("TestOverloading") and
  count(Method m |
    m.getDeclaringType() = c and
    (m.hasName("F") or m.hasName("F<>"))
  ) = 6
select c
