/**
 * @name ImportTimeScope
 * @description ImportTimeScope Test
 * @kind table
 * @problem.severity warning
 */

import python

from Scope s, string name, Object val
where
  name != "__name__" and
  (
    exists(ModuleObject m |
      m.getModule() = s and
      m.attributeRefersTo(name, val, _)
    )
    or
    exists(ClassObject cls |
      cls.getPyClass() = s and
      cls.declaredAttribute(name) = val
    )
  )
select s.toString(), name, val.toString()
