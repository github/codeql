import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis

class Config extends Configuration {
  Config() { this = "UpperBoundConfig" }

  override predicate isUnconvertedSink(Expr e) { e instanceof VariableAccess }
}

from VariableAccess expr
select expr, upperBound(expr).toString()
