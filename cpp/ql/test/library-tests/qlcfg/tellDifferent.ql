import Compare

from
  ControlFlowNode n1, ControlFlowNode n2, string msg
where
  differentEdge(n1, n2, msg)
select
  getScopeName(n1), n1, n2, msg
