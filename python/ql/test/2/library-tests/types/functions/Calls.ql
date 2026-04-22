import python
private import LegacyPointsTo

from FunctionObject func, ControlFlowNode call
where func.getACall() = call
select call.getLocation().getStartLine(), call.toString(), func.toString()
