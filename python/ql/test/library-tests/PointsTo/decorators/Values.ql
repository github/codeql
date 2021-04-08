import python
import semmle.python.pointsto.PointsTo
import semmle.python.objects.ObjectInternal

from NameNode f, Context ctx, ObjectInternal v
where
  f.getLocation().getFile().getBaseName() = "test.py" and
  PointsTo::pointsTo(f, ctx, v, _)
select f, ctx, v
