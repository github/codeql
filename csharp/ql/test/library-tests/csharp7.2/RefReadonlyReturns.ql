import csharp

from Callable c
where
  c.fromSource() and
  c.getAnnotatedReturnType().isReadonlyRef()
select c
