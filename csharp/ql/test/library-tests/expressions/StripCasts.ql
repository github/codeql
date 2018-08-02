import csharp

from Expr e, Expr stripped
where stripped = e.stripCasts() and e != stripped
select e, stripped
