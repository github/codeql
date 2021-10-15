import default

from LocalVariableDeclExpr lvde, Expr e, int index
where e.isNthChildOf(lvde, index)
select lvde, index, e
