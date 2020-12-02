import cpp

from Expr e
where exists(e.toString())
select e, e.getType()
