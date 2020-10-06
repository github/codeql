import experimental.semmle.code.cpp.rangeanalysis.ExtendedRangeAnalysis

from VariableAccess expr, float lower, float upper
where
  lower = lowerBound(expr) and
  upper = upperBound(expr)
select expr, lower, upper
