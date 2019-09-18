import javascript

from Variable v, Expr e
where e = v.getAnAssignedExpr()
select e, e.analyze().getAValue()
