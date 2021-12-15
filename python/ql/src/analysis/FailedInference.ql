import python
import semmle.python.pointsto.PointsTo

from ClassValue cls, string reason
where Types::failedInference(cls, reason)
select cls, reason
