import csharp

from Case c, Expr e
where e = c.getPattern().stripCasts()
select c, e
