import cpp
import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis

from ArrayExpr ae
where lowerBound(ae.getArrayOffset()) < 0
select ae