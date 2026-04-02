import python
private import LegacyPointsTo

from ReraisingNode r
select r.getLocation().getStartLine(), r, r.getARaisedType().toString()
