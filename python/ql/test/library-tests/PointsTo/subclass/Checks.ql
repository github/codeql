import python
import semmle.python.pointsto.PointsTo

from Value sup, Value cls
where Expressions::requireSubClass(cls, sup)
select cls, sup
