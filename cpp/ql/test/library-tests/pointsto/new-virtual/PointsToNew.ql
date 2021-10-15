import cpp
import semmle.code.cpp.pointsto.PointsTo

class MyPointsTo extends PointsToExpr {
  override predicate interesting() { any() }
}

from MyPointsTo new, Element loc
where new.pointsTo() = loc
select new, loc
