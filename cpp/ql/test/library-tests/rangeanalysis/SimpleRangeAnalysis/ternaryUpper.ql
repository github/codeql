import cpp
import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis

class Config extends Configuration {
  Config() { this = "TernaryUpperConfig" }

  override predicate isUnconvertedSink(Expr e) {
    e instanceof ConditionalExpr or
    exists(ConditionalExpr ce | e = [ce.getThen(), ce.getElse()])
  }
}

from ConditionalExpr ce
select ce, upperBound(ce), upperBound(ce.getThen()), upperBound(ce.getElse())
