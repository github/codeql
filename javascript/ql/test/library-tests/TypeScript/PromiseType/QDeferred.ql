import javascript

from Expr e
where e.getType().hasUnderlyingType("q", "Deferred")
select e
