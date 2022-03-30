import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis

from VariableAccess expr
select expr, lowerBound(expr).toString()
