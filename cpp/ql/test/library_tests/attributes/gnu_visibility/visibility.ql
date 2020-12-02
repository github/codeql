import cpp

from Element e, Attribute a
where
  a = e.(Variable).getAnAttribute() or
  a = e.(Function).getAnAttribute() or
  a = e.(Struct).getAnAttribute()
select e, a, a.getAnArgument()
