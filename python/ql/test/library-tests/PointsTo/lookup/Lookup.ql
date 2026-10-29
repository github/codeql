import python

from string l, NameNode n
where
  n.getLocation().getFile().getShortName() = "test.py" and
  (
    n.isGlobal() and l = "global"
    or
    n.isLocal() and l = "local"
    or
    n.isNonLocal() and l = "non-local"
  )
select n.getLocation().getStartLine(), n.getId(), l
