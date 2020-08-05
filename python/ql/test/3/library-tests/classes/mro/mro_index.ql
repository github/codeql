/**
 * @name class_attr
 * @kind test
 * @problem.severity warning
 */

import python

from ClassObject cls, ClassObject sup, int index
where
  sup = cls.getMroItem(index) and
  not cls.isC()
select cls.toString(), index, sup.toString()
