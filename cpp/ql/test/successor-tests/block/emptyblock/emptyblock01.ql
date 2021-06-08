import cpp

from BlockStmt s, int i, Stmt f, boolean succ
where
  s.getParentStmt().hasChild(s, i) and
  s.getParentStmt().hasChild(f, i + 1) and
  if f = s.getASuccessor() then succ = true else succ = false
select s, i, f, count(s.getASuccessor()), succ
