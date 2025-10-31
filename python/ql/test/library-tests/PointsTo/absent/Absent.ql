import python
private import LegacyPointsTo
import semmle.python.objects.Modules

from Value val, ControlFlowNodeWithPointsTo f
where f.pointsTo(val)
select f, val
