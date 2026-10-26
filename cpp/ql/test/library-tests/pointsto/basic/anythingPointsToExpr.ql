import cpp
import semmle.code.cpp.pointsto.PointsTo

class AccessPT extends PointsToExpr {
  override predicate interesting() {
    this instanceof VariableAccess and
    exists(FunctionCall use |
      use = this.getParent() and
      use.getTarget().hasName("use")
    )
  }
}

from Element loc
where anythingPointsTo(loc)
select loc
