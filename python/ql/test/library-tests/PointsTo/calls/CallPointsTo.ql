import python

from CallNode call, Value func
where call.getFunction().pointsTo(func)
select call.getLocation().getStartLine(), call.toString(), func.toString()
