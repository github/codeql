import csharp

from Callable c
where c.fromSource()
select c, c.getExpressionBody()
