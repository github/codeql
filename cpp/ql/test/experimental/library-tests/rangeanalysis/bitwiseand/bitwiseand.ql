import experimental.semmle.code.cpp.rangeanalysis.ExtendedRangeAnalysis

from Operation expr, QlBuiltins::BigInt lower, QlBuiltins::BigInt upper
where
  (expr instanceof BitwiseAndExpr or expr instanceof AssignAndExpr) and
  lower = lowerBound(expr) and
  upper = upperBound(expr)
select expr, lower.toString(), upper.toString()
