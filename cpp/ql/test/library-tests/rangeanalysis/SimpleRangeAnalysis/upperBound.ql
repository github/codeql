import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis
import semmle.code.cpp.rangeanalysis.RangeAnalysisUtils

from VariableAccess expr, QlBuiltins::BigInt u, string s
where
  u = upperBound(expr) and
  if u = infinityAsBigInt()
  then s = "Infinity"
  else if u = -infinityAsBigInt()
  then s = "-Infinity"
  else s = u.toString()
select expr, s
