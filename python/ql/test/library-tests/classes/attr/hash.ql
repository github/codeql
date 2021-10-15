/**
 * @name class_attr
 * @kind test
 * @problem.severity warning
 */

import python

from ClassObject cls, int line, Object obj
where
  cls.hasLocationInfo(_, line, _, _, _) and
  obj = cls.lookupAttribute("__hash__") and
  not cls.isC() and
  not obj = theObjectType().lookupAttribute("__hash__") and
  not obj = theTypeType().lookupAttribute("__hash__")
select line, cls.toString(), obj.toString()
