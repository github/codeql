import csharp

from Parameter p
where
  p.fromSource() and
  p.isIn()
select p
