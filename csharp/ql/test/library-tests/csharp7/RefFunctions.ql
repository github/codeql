import csharp

from Callable f
where
  f.getAnnotatedReturnType().isRef() and
  f.fromSource()
select f
