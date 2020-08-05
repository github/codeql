/**
 * @name class_attr
 * @kind test
 * @problem.severity warning
 */

import python

from ClassObject cls, int line, string name, Object obj
where
  cls.hasLocationInfo(_, line, _, _, _) and
  obj = cls.lookupAttribute(name) and
  not cls.isC() and
  not name.matches("\\_\\_%\\_\\_")
select line, cls.toString(), name, obj.toString()
