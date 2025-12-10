import python
private import LegacyPointsTo

from ControlFlowNode call, Value func
where call = func.getACall()
select call.getLocation().getStartLine(), call.toString(), func.toString()
