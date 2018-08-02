import csharp

from Callable c
where c.fromSource()
  and c.returnsRefReadonly()
select c
