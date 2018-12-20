import csharp

from Callable f
where
  f.returnsRef() and
  f.fromSource()
select f
