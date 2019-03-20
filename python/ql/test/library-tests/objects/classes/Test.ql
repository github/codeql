import python

private import semmle.python.objects.ObjectInternal

from ClassObjectInternal cls, ControlFlowNode f
where cls.introduced(f, _)
select cls.getName(), f

