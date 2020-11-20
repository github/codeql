import csharp

from Expr e
where e.fromSource()
select e, e.getType().toString()
