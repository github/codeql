/**
 * @name ClassAttribute
 * @description Test for Class attributes
 * @kind test
 */

import python

from ClassObject cls, string name, string kind
where
not cls.isBuiltin() and
not name.matches("\\_\\_%\\_\\_") and
(
  cls.hasAttribute(name) and kind = "has"
  or
  cls.declaresAttribute(name) and kind = "declares"
)
select cls.toString(), kind ,name

