import csharp

from Struct s
where
  s.fromSource() and
  s.isRef()
select s
