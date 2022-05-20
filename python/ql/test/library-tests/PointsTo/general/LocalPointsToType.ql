import python
import interesting
import Util

from int line, ControlFlowNode f, Object o, ClassObject cls
where
  of_interest(f, line) and
  f.refersTo(o, cls, _)
select line, f.toString(), repr(o), repr(cls)
