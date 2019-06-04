
import python
import semmle.python.objects.Modules

from Value val, ControlFlowNode f
where //val = Value::named(name) and
f.pointsTo(val)
select f, val

