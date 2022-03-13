import java
import semmle.code.java.semantic.SemanticBound
import semmle.code.java.semantic.SemanticExpr
import semmle.code.java.semantic.SemanticExprSpecific
import semmle.code.java.semantic.SemanticSSA
import semmle.code.java.semantic.SemanticGuard
import semmle.code.java.semantic.analysis.RangeAnalysis
import semmle.code.java.dataflow.RangeAnalysis
import semmle.code.java.dataflow.SSA
import semmle.code.java.controlflow.Guards
import semmle.code.java.semantic.analysis.RangeUtils as RU

private string getDirectionString(boolean d) {
  result = "upper" and d = true
  or
  result = "lower" and d = false
}

private predicate interestingLocation(Location loc) {
  //  loc.getFile().getBaseName() = "AccurateMath.java" and
  //  loc.getStartLine() in [2079 .. 2079] and
  any()
}

query predicate exprBound(
  Expr e, string eClass, Bound b, int delta, string direction, string reason, string message
) {
  interestingLocation(e.getLocation()) and
  message =
    strictconcat(string messagePart, boolean upper |
      direction = getDirectionString(upper) and
      (
        exists(SemExpr semExpr, SemBound semBound, SemReason semReason |
          semExpr = getSemanticExpr(e) and semBound = getSemanticBound(b)
        |
          semBounded(semExpr, semBound, delta, upper, semReason) and
          reason = semReason.toString()
        ) and
        messagePart = "sem"
        or
        exists(Reason astReason |
          bounded(e, b, delta, upper, astReason) and
          reason = astReason.toString()
        ) and
        messagePart = "ast"
      )
    |
      messagePart, "+"
    ) and
  eClass = concat(e.getAQlClass(), ", ") and
  message != "ast+sem"
}
