import cpp

from ControlFlowNode n
where not reachable(n)
select n.getLocation().getStartLine(), n
