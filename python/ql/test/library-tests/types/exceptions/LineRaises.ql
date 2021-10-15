import python

from RaisingNode r, string type
where
  type = r.getARaisedType().toString()
  or
  type = "Unknown" and r.raisesUnknownType()
  or
  not exists(r.getARaisedType()) and
  not r.raisesUnknownType() and
  type = "None"
select r.getNode().getLocation().getStartLine(), type
