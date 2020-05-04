import python

from CallNode call, Object func
where call.getFunction().refersTo(func)
select call.getLocation().getStartLine(), call.toString(), func.toString()
