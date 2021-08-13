import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis

class Config extends Configuration {
  Config() { this = "LowerBoundConfig" }

  override predicate isUnconvertedSink(Expr e) { e instanceof VariableAccess }
}

from VariableAccess expr
select expr, lowerBound(expr).toString()
