import cpp
import semmle.code.cpp.pointsto.PointsTo

class ReportPT extends PointsToExpr {
  override predicate interesting() {
    exists(FunctionCall report |
      report.getTarget().hasName("report") and
      report.getAnArgument() = this
    )
  }
}

from ReportPT report, Element loc
where report.pointsTo() = loc
select report, loc
