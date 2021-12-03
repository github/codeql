import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis

from VariableAccess expr
select expr, upperBound(expr).toString()
