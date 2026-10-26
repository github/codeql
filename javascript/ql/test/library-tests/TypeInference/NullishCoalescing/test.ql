import javascript

from Variable v, Expr e
where e = v.getAnAssignedExpr()
select v, e.analyze().getAValue()
