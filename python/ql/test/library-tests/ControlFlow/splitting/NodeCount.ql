import python

from AstNode a, Scope s
where
  not a instanceof Import and
  not a instanceof If and
  not a instanceof AssignStmt and
  not a instanceof ExprStmt and
  a.getScope() = s and
  s instanceof Function
select a.getLocation().getStartLine(), s.getName(), a, count(a.getAFlowNode())
