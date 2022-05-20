import experimental.semmle.code.cpp.rangeanalysis.ExtendedRangeAnalysis

from Operation expr, float lower, float upper
where
  (expr instanceof BitwiseAndExpr or expr instanceof AssignAndExpr) and
  lower = lowerBound(expr) and
  upper = upperBound(expr)
select expr, lower, upper
