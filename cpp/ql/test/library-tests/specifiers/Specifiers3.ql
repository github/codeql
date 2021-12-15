/**
 * @name Specifiers3
 */

import cpp

from Variable v, Type t
where
  v.getType() = t and
  t.isConst()
select v.getLocation().getStartLine(), v
