/**
 * @name LocalPointsTo
 * @description Insert description here...
 * @kind table
 * @problem.severity warning
 */

import python
import interesting
import Util

from int line, ControlFlowNode f, Object o
where
  of_interest(f, line) and
  f.refersTo(o)
select line, f.toString(), repr(o)
