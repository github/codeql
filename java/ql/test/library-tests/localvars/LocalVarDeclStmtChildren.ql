import default

from LocalVariableDeclStmt lvds, Expr e, int index
where e.isNthChildOf(lvds, index)
select lvds, index, e
