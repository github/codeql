import python
private import LegacyPointsTo
import interesting

from int line, ControlFlowNodeWithPointsTo f, Object o, ImportTimeScope n
where
  of_interest(f, line) and
  f.refersTo(o) and
  f.getScope() = n
select n.toString(), line, f.toString(), o.toString()
