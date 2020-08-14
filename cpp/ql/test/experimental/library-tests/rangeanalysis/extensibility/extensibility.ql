import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis
import experimental.semmle.code.cpp.models.interfaces.SimpleRangeAnalysisExpr

from VariableAccess expr, float lower, float upper
where
  lower = lowerBound(expr) and
  upper = upperBound(expr)
select expr, lower, upper
