/**
 * @name class_attr
 * @kind test
 * @problem.severity warning
 */

import python

from ClassObject cls, ClassObject l, ClassObject r
where
  not cls.isC() and
  r = cls.nextInMro(l)
select cls.toString(), l.toString(), r.toString()
