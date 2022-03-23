import java

from BlockStmt b, Expr e
where e.getParent() = b
select b, e
