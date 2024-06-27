import cpp
import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis

from ConditionalExpr ce
select ce, upperBound(ce).toString(), upperBound(ce.getThen()).toString(),
  upperBound(ce.getElse()).toString()
