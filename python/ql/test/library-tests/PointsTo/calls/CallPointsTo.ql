import python
private import LegacyPointsTo

from CallNode call, Value func
where call.getFunction().(ControlFlowNodeWithPointsTo).pointsTo(func)
select call.getLocation().getStartLine(), call.toString(), func.toString()
