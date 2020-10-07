import csharp
import semmle.code.csharp.dataflow.RangeAnalysis

private string getDirectionString(boolean d) {
  result = "upper" and d = true
  or
  result = "lower" and d = false
}

from Expr e, Bound b, int delta, boolean upper
where bounded(e, b, delta, upper)
select e, b.getAQlClass(), delta, getDirectionString(upper)
