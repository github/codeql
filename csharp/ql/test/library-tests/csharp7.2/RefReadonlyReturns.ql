import csharp

from Callable c
where
  c.fromSource() and
  c.getAnnotatedReturnType().getAnnotation().isReadonlyRef()
select c
