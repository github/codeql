import python

from NameNode n, string l
where
  n.isLoad() and
  (
    n.isGlobal() and l = "global"
    or
    n.isLocal() and l = "local"
    or
    n.isNonLocal() and l = "non-local"
    or
    not n.isGlobal() and
    not n.isLocal() and
    not n.isNonLocal() and
    l = "none"
  )
select n.getLocation().getStartLine(), n.toString(), l
