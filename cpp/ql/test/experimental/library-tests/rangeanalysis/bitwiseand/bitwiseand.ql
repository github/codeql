import experimental.semmle.code.cpp.rangeanalysis.ExtendedRangeAnalysis

class Config extends Configuration {
  Config() { this = "BitwiseAndConfig" }

  override predicate isUnconvertedSink(Expr e) {
    e instanceof BitwiseAndExpr or e instanceof AssignAndExpr
  }
}

from Operation expr, float lower, float upper
where
  (expr instanceof BitwiseAndExpr or expr instanceof AssignAndExpr) and
  lower = lowerBound(expr) and
  upper = upperBound(expr)
select expr, lower, upper
