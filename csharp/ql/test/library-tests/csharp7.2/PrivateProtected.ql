import csharp

from Modifiable m
where
  m.fromSource() and
  m.isPrivate() and
  m.isProtected()
select m
