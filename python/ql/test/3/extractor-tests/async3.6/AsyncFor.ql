import python

from For f, string kind
where
  f instanceof AsyncFor and kind = "async"
  or
  not f instanceof AsyncFor and kind = "normal"
select f.getLocation().getStartLine(), f.toString(), kind
