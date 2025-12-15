import python
private import LegacyPointsTo

from ControlFlowNodeWithPointsTo f, Object o, ControlFlowNode x
where f.refersTo(o, x)
select f.getLocation().getStartLine(), f.toString(), o.toString(), x.getLocation().getStartLine()
