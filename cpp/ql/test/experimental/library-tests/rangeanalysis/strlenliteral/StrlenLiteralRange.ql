import cpp
import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis
import experimental.semmle.code.cpp.rangeanalysis.extensions.StrlenLiteralRangeExpr

from FunctionCall fc
select fc, upperBound(fc), lowerBound(fc)
