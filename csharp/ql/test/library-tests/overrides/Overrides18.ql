/**
 * @name Test for overrides
 */

import csharp

from Class c, Method m
where
  m.fromSource() and
  not m.isAbstract() and
  c.hasMethod(m) and
  c.getName() = "D"
select m, m.getDeclaringType().getName()
