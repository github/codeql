import python

from PyFunctionObject f, string type
where
  type = f.getARaisedType().toString()
  or
  type = "Unknown" and f.raisesUnknownType()
  or
  not exists(f.getARaisedType()) and
  not f.raisesUnknownType() and
  type = "None"
select f.toString(), type
