import java
import semmle.code.java.dataflow.RangeAnalysis

private string getDirectionString(boolean d) {
  result = "upper" and d = true
  or
  result = "lower" and d = false
}

from Expr e, Bound b, int delta, boolean upper, Reason reason
where bounded(e, b, delta, upper, reason)
select e, b.toString(), delta, getDirectionString(upper), reason
