import python
import semmle.python.objects.Modules

from Value val, ControlFlowNode f
where f.pointsTo(val)
select f, val
