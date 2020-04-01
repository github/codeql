import python

from CallNode call, FunctionObject func
where call.getFunction().refersTo(func)
select call.getLocation().getStartLine(), call.toString(), func.toString()
