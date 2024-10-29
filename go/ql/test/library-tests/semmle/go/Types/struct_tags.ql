import go

from StructType s, Field f, string tag
where
  f = s.getOwnField(_, _) and
  tag = f.getTag() and
  tag != ""
select s.pp(), f, tag
