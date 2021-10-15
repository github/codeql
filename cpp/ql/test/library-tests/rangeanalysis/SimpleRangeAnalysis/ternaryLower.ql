import cpp
import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis

from ConditionalExpr ce
select ce, lowerBound(ce), lowerBound(ce.getThen()), lowerBound(ce.getElse())
