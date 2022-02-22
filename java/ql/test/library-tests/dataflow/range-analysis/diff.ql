import java
import semmle.code.java.semantic.SemanticBound
import semmle.code.java.semantic.SemanticExpr
import semmle.code.java.semantic.analysis.RangeAnalysis
import semmle.code.java.dataflow.RangeAnalysis

private string getDirectionString(boolean d) {
  result = "upper" and d = true
  or
  result = "lower" and d = false
}

from Expr e, Bound b, int delta, boolean upper, string reason, string message
where
  exists(SemReason semReason |
    semBounded(getSemanticExpr(e), getSemanticBound(b), delta, upper, semReason) and
    reason = semReason.toString()
  ) and
  not exists(Reason astReason |
    bounded(e, b, delta, upper, astReason) and reason = astReason.toString()
  ) and
  message = "semantic only"
  or
  not exists(SemReason semReason |
    semBounded(getSemanticExpr(e), getSemanticBound(b), delta, upper, semReason) and
    reason = semReason.toString()
  ) and
  exists(Reason astReason |
    bounded(e, b, delta, upper, astReason) and reason = astReason.toString()
  ) and
  message = "AST only"
select e, b.toString(), delta, getDirectionString(upper), reason, message
