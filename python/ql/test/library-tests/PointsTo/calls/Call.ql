
import python

from ControlFlowNode call, FunctionObject func

where call = func.getACall()
select call.getLocation().getStartLine(), call.toString(), func.toString()