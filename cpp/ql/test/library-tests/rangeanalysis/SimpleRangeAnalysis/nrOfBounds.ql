import cpp
import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis

from Expr e
select e, SimpleRangeAnalysisInternal::estimateNrOfBounds(e)
