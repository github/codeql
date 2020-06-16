import python

from ControlFlowNode f, Object o, ControlFlowNode x
where f.refersTo(o, x)
select f.getLocation().getStartLine(), f.toString(), o.toString(), x.getLocation().getStartLine()
