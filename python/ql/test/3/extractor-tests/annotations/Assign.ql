import python

from AnnAssign a, string value
where
  value = a.getValue().toString()
  or
  not exists(a.getValue()) and value = "----"
select a.getLocation().getStartLine(), a.toString(), a.getTarget().toString(),
  a.getAnnotation().toString(), value
