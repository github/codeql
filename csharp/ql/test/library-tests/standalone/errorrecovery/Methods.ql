import csharp

from Callable c
where c.fromSource()
select c, count(Call call | call.getTarget() = c)
