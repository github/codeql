import python

from Name n, GlobalVariable v, boolean reachable
where
  n.getVariable() = v and
  exists(ExprStmt s | s.getValue() = n) and
  if exists(ControlFlowNode f | f.getNode() = n) then reachable = true else reachable = false
select n.getLocation().getStartLine(), v.getId(), reachable
