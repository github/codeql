import cpp

from BreakStmt b, Stmt s
where b.getBreakable() = s
select b, s
