/**
 * @name Test for methods
 */

import csharp

from Class c, Method m
where
  c.hasName("TestOverloading") and
  m.getDeclaringType() = c and
  m.hasName("F") and
  m.getParameter(0).getType() instanceof ObjectType
select c, m, m.getParameter(0).getType().toString()
