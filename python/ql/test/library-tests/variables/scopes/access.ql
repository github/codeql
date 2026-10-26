import python

from Variable v, Scope s, Name n
where
  n = v.getAnAccess() and
  s = v.getScope()
select s, v, n
