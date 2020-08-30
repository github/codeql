import python
import interesting

from int line, ControlFlowNode f, Object o, ImportTimeScope n
where
  of_interest(f, line) and
  f.refersTo(o) and
  f.getScope() = n
select n.toString(), line, f.toString(), o.toString()
