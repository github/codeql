import python

from ControlFlowNode p, Scope s
where
  p.getScope() = s and
  (exists(p.getATrueSuccessor()) or exists(p.getAFalseSuccessor())) and
  s instanceof Function
select p.getLocation().getStartLine(), s.getName(), p, strictcount(p.getASuccessor())
