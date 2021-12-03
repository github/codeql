import python

from LocalVariable l, string kind
where
  l instanceof FastLocalVariable and kind = "fast"
  or
  l instanceof NameLocalVariable and kind = "name"
select l, l.getScope(), kind
