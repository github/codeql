/**
 * @name class_attr
 * @kind test
 * @problem.severity warning
 */

import python
private import LegacyPointsTo

from ClassObject cls, string name, Object what
where
  (
    cls.getName() = "list" or
    cls.getASuperType().getName() = "list"
  ) and
  cls.lookupAttribute(name) = what
select cls.toString(), name, what.toString()
