import python
private import LegacyPointsTo

from FunctionObject f
where f.neverReturns()
select f.toString()
