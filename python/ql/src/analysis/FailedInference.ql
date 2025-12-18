import python
private import LegacyPointsTo

from ClassValue cls, string reason
where Types::failedInference(cls, reason)
select cls, reason
