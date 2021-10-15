import python

from RaisingNode r
where r.raisesUnknownType()
select r.getLocation().getStartLine(), r.toString()
