/**
 * @name LocalPointsTo
 * @description Insert description here...
 * @kind table
 * @problem.severity warning
 */

import python
private import LegacyPointsTo
import interesting
import Util

from int line, ControlFlowNodeWithPointsTo f, Object o
where
  of_interest(f, line) and
  f.refersTo(o)
select line, f.toString(), repr(o)
