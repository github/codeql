
import python
import semmle.python.pointsto.PointsTo

from ClassObject cls, string reason

where
PointsTo::Types::failed_inference(cls, reason)

select cls, reason

