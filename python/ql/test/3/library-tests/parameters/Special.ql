import python

from Parameter p, string type
where
  p.isKwargs() and type = "kwargs"
  or
  p.isVarargs() and type = "varargs"
  or
  not p.isKwargs() and not p.isVarargs() and type = "normal"
select p.getName(), type
