import experimental.semmle.code.cpp.rangeanalysis.ExtendedRangeAnalysis

class Config extends Configuration {
  Config() { this = "ExtendedConfig" }

  override predicate isUnconvertedSink(Expr e) { e instanceof VariableAccess }
}

from VariableAccess expr, float lower, float upper
where
  lower = lowerBound(expr) and
  upper = upperBound(expr)
select expr, lower, upper
