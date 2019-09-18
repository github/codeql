import cpp
import semmle.code.cpp.pointsto.PointsTo

class ReturnPT extends PointsToExpr {
  override predicate interesting() {
    this instanceof VariableAccess and
    this.getParent() instanceof ReturnStmt
  }
}

from ReturnPT return
select return, return.pointsTo()
