import javascript

from Expr e
where e.getType() instanceof UnknownType
select e, e.getType()
