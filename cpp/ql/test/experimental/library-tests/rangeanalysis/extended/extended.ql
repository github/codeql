import experimental.semmle.code.cpp.rangeanalysis.ExtendedRangeAnalysis

from VariableAccess expr, QlBuiltins::BigInt lower, QlBuiltins::BigInt upper
where
  lower = lowerBound(expr) and
  upper = upperBound(expr)
select expr, lower.toString(), upper.toString()
