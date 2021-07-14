import csharp

from Expr e, Expr stripped
where stripped = e.stripCasts() and e != stripped and e.fromSource()
select e, stripped
