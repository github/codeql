import cpp

from ContinueStmt c, Stmt s
where c.getContinuable() = s
select c, s
