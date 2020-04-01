import python

from ControlFlowNode call, FunctionValue func
where call = func.getACall()
select call.getLocation().getStartLine(), call.toString(), func.toString()
