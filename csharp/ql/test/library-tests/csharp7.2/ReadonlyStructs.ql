import csharp

from Struct s
where
  s.fromSource() and
  s.isReadonly()
select s
