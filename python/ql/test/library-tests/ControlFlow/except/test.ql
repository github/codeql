import python

from GlobalVariable v, Name n, ControlFlowNode f
where v.getId().charAt(0) = "e" and n.uses(v) and f.getNode() = n
select v.getId()
