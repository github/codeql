import cpp

from Namespace n, string sane, string parent
where
  (if n.hasName(n.getName()) then sane = "Yes" else sane = "No") and
  if exists(n.getParentNamespace())
  then parent = n.getParentNamespace().toString()
  else parent = "<none>"
select n, n.getName(), n.getQualifiedName(), sane, parent
