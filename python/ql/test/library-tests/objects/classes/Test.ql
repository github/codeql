import python

private import semmle.python.objects.ObjectInternal
private import semmle.python.pointsto.PointsTo2

from ClassObjectInternal cls, ControlFlowNode f
where cls.introduced(f, _)
select cls.getName(), f

