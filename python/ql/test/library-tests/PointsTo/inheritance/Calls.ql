import python
private import LegacyPointsTo

from Call c, FunctionObject f
where f.getACall().getNode() = c
select c.getLocation().getStartLine(), f.toString(), f.getFunction().getLocation().getStartLine()
