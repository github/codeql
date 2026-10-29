import python
private import LegacyPointsTo

from int line, ControlFlowNodeWithPointsTo f, Value v
where
  any(ExprStmt s).getValue() = f.getNode() and
  line = f.getLocation().getStartLine() and
  f.pointsTo(v)
select line, v
