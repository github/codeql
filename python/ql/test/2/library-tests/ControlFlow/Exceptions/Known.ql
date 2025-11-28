import python
private import LegacyPointsTo

from RaisingNode r
select r.getLocation().getStartLine(), r.toString(), r.getARaisedType().toString()
