import python
private import LegacyPointsTo
import interesting
import Util

from int line, ControlFlowNodeWithPointsTo f, Object o, ClassObject cls
where
  of_interest(f, line) and
  f.refersTo(o, cls, _)
select line, f.toString(), repr(o), repr(cls)
