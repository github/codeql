import cpp

from Expr e
where e.getType() instanceof ErroneousType
and e.fromSource()
select e
