import csharp

from Modifiable d, string s
where
  d.fromSource() and
  (
    d.isPrivate() and s = "private"
    or
    d.isInternal() and s = "internal"
  )
select d, s
