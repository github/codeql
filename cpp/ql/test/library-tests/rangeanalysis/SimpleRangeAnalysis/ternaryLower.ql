import cpp
import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis

from ConditionalExpr ce
select ce, lowerBound(ce).toString(), lowerBound(ce.getThen()).toString(),
  lowerBound(ce.getElse()).toString()
