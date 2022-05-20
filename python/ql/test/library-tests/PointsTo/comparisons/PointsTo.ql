import python

from int line, ControlFlowNode f, Value v
where
  any(ExprStmt s).getValue() = f.getNode() and
  line = f.getLocation().getStartLine() and
  f.pointsTo(v)
select line, v
